//
//  PasswordViewController+Data.swift
//   PassLock
//
//  Created by Melo Dreek on 2023/2/19.
//  Copyright © 2023 PassLock. All rights reserved.
//

import KakaUIKit
import KakaFoundation
import KakaObjcKit
import CloudKit
import AppGroupKit
import MBProgressHUD

extension PasswordViewController: UITableViewDataSource, UITableViewDelegate {
    
    @objc func refreshDataAction() {
        let curPassbook = AppICloudManager.shared.currentPassbook
        self.passTypeView.recordModel = curPassbook
        
        AppICloudManager.shared.queryPrivateItemList(recordType: curPassbook.recordType, itemType: viewModel.itemType) { models in
            self.mj_header.endRefreshing()

            self.viewModel.healthRisk = .allData
            self.viewModel.originDataArray = models
            for subModel in models {
                LocalNotificationManager.shared.addOrUpdatePassNoti(subModel)
            }
            self.reloadTableViews()
        } fail: { error in
            self.mj_header.endRefreshing()
            self.view.makeToast(error?.localizedDescription)
        }

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.indexArray.count == 0 ? viewModel.emptyDataArray().count : self.viewModel.indexArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.indexArray.count == 0 {
            let noneType = viewModel.emptyDataArray()[section]
            return noneType == .socialEvents ? viewModel.emptySocialArray().count : 1
        }else{
            let dataArray = self.viewModel.dataArray(section)
            return dataArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewModel.indexArray.count > 0 {
            let dataArray = self.viewModel.dataArray(indexPath.section)
            let model = dataArray[indexPath.row]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "PassItemTableViewCell", for: indexPath) as! PassItemTableViewCell
            cell.update(model: model, healthArray: self.viewModel.sortHealthDataSource(model))
            return cell
        }else{
            let noneType = viewModel.emptyDataArray()[indexPath.section]
            if noneType == .amazingTip {
                let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyAmazingTableCell", for: indexPath) as! EmptyAmazingTableCell
                cell.darkwebCallBack = { [weak self] () in
                    self?.darkwebDetectClick()
                }
                return cell
            } else if noneType == .socialEvents {
                let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyNewsEventTableCell", for: indexPath) as! EmptyNewsEventTableCell
                cell.model = viewModel.emptySocialArray()[indexPath.row]
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyPrivacyReportTableCell", for: indexPath) as! EmptyPrivacyReportTableCell
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if viewModel.indexArray.count == 0 {
            let noneType = self.viewModel.emptyDataArray()[indexPath.section]
            if noneType == .socialEvents {
                let newsModel = viewModel.emptySocialArray()[indexPath.row]
                self.newsActileClick(newsModel)
            }
        }else{
            let dataArray = self.viewModel.dataArray(indexPath.section)
            let model = dataArray[indexPath.row]
            
            self.clickPrivateItem(model)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if viewModel.indexArray.count == 0 {
            return UITableView.automaticDimension
        }else{
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if viewModel.indexArray.count == 0 {
            return viewModel.emptyHeadStrArray()[section]
        }else{
            return viewModel.indexArray[section]
        }
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return viewModel.indexArray
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return viewModel.indexArray.count > 0 ? true : false
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if viewModel.indexArray.count == 0 {
            return nil
        }
        
        let dataArray = self.viewModel.dataArray(indexPath.section)
        let model = dataArray[indexPath.row]
        
        let action1 = UIContextualAction(style: .destructive, title: nil) { [weak self] action, view, finish in
            guard let wSelf = self else { return }
            
            wSelf.passGroupCellDidDelete(model: model)
        }
        action1.image = Reasource.systemNamed("trash.fill", color: .white)
        action1.backgroundColor = UIColor.systemRed
        
        let isCollection = model.isCollection
        let action2 = UIContextualAction(style: .normal, title: nil) { [weak self] action, view, finish in
            guard let wSelf = self else { return }
            wSelf.passGroupCellDidCollect(model: model)
        }
        
        action2.image = Reasource.systemNamed(isCollection ? "star.fill" : "star", color: .white)
        action2.backgroundColor = UIColor.systemBlue
                
        return UISwipeActionsConfiguration(actions: [action1, action2])
            
    }
    
}

extension PasswordViewController {
    
    @objc func reloadTableViews() {
        
        let isNoneData = self.viewModel.indexArray.count == 0
        let isPasswordType = viewModel.itemType == .allItem || viewModel.itemType == .password
        
        if isPasswordType {
            self.tableView.tableHeaderView = isNoneData ? nil : self.healthView
        }else{
            self.tableView.tableHeaderView = nil
        }
        
        if isNoneData {
            self.view.makeToast("No data available".localStr())
            self.tableView.tableFooterView = nil
        }else{
            self.footView.size = CGSize(width: self.view.width, height: PasswordTableFootView.allHeight(maxWidth: self.view.width, status: viewModel.syncStatus))
            self.tableView.tableFooterView = self.footView
            self.footView.update(dataArray: viewModel.originDataArray, viewModel: viewModel)
        }
        
        self.tableView.reloadData()
                
        if isPasswordType {
            let securety = self.viewModel.groupSorted(.securety).count
            let easy = self.viewModel.groupSorted(.easyGuess).count
            let duplicate = self.viewModel.groupSorted(.duplicate).count
            self.healthView.updateData(safe: Double(securety), easy: Double(easy), duplicate: Double(duplicate))
        }
                
    }
}
