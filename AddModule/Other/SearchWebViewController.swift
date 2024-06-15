//
//  SearchWebViewController.swift
//  PassLock
//
//  Created by Melo on 2023/9/2.
//

import KakaFoundation
import KakaUIKit
import SDWebImage
import MBProgressHUD
import AppGroupKit


class SearchWebViewController: SuperViewController {
    override func preSetupSubViews() {
        super.preSetupSubViews()
        
        contentView.addSubview(tableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = contentView.bounds
    }
    
    override func preSetupHandleBuness() {
        super.preSetupHandleBuness()
        
        self.title = "Search for URL".localStr()
        self.dataArray = SandboxFileManager.shared.readPrivateWebsiteModel()
        
        self.tableView.reloadData()
    }
    
    var onSelectCallBack: ((WebsiteInfoModel)->Void)?
    
    
    lazy var dataArray: [WebsiteInfoModel] = {
        return [WebsiteInfoModel]()
    }()
    
    lazy var tableView: UITableView = {
        
        let view = UITableView(frame: self.view.bounds, style: .insetGrouped)
        view.dataSource = self
        view.delegate = self
        view.rowHeight = UITableView.automaticDimension
        view.contentInsetAdjustmentBehavior = .automatic
        view.register(UITableViewCell.self, forCellReuseIdentifier: "WebsiteTableViewCell")
        view.register(WebsiteOpsViewCell.self, forCellReuseIdentifier: "WebsiteOpsViewCell")
        view.register(SearchEngineHeadCell.self, forCellReuseIdentifier: "SearchEngineHeadCell")
        return view
    }()
    
}

extension SearchWebViewController: UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else{
            return dataArray.count == 0 ? 1 : dataArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchEngineHeadCell", for: indexPath) as! SearchEngineHeadCell
            cell.onSelectCallBack = { [weak self] (webModel) in
                guard let wSelf = self else { return }
                wSelf.handleNewModel(webModel)
            }
            cell.onVIPCallBack = { [weak self] () in
                guard let wSelf = self else { return }
                KakaAppStoreManager.presentPurcharseVC(wSelf)
            }
            cell.onSearchCallBack = { [weak self] (searchUrl, tagText, searchEngine) in
                guard let wSelf = self else { return }
                let webVC = WebsiteEngineViewController(urlStr: searchUrl, searchKey: tagText, searchEngine: searchEngine)
                webVC.onSelectCallBack = { [weak self] (webModel) in
                    guard let wSelf = self else { return }
                    wSelf.handleNewModel(webModel)
                }
                webVC.onEngineErrorBlock = { [weak self] () in
                    guard let headCell = self?.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? SearchEngineHeadCell else { return }
                    headCell.selectSearchEngine()
                }
                wSelf.navigationController?.pushViewController(webVC, animated: true)
            }
            return cell
        }else{
            if dataArray.count == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "WebsiteOpsViewCell", for: indexPath) as! WebsiteOpsViewCell
                return cell
            }else{
                let imageSize = CGSizeMake(25.ckValue(), 25.ckValue())
                let cell = tableView.dequeueReusableCell(withIdentifier: "WebsiteTableViewCell", for: indexPath)
                let model = dataArray[indexPath.row]
                let placeImage = Reasource.systemNamed("link", color: appMainColor).kaka_imageByResize(to: imageSize)
                
                var cellConfig = UIListContentConfiguration.sidebarSubtitleCell()
                cellConfig.image = placeImage
                cellConfig.text = model.webName
                cellConfig.secondaryText = model.dominUrlStr()
                cellConfig.imageProperties.maximumSize = imageSize
                cellConfig.textProperties.color = UIColor.label
                cellConfig.textProperties.numberOfLines = 1
                cellConfig.secondaryTextProperties.numberOfLines = 1
                cellConfig.textProperties.lineBreakMode = .byTruncatingMiddle
                cellConfig.secondaryTextProperties.lineBreakMode = .byTruncatingMiddle
                
                cellConfig.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 15)
                cellConfig.imageToTextPadding = 15
                
                cell.accessoryType = .disclosureIndicator
                cell.contentConfiguration = cellConfig
                
                SDWebImageManager.shared.loadImage(with: URL(string: model.imageUrlStr()), progress: nil) { (image, data, error, cache, finish, url) in
                    cellConfig.image = image?.kaka_reSize(reSize: imageSize) ?? placeImage
                    cell.contentConfiguration = cellConfig
                }
                return cell
            }
        }
    }
    
    
    func handleNewModel(_ webModel: WebsiteInfoModel) {
        
        var index = -1
        for i in 0..<self.dataArray.count {
            let subModel = dataArray[i]
            if subModel.dominUrlStr() == webModel.dominUrlStr() {
                index = i
            }
        }
        
        if index > 0 {
            let sameModel = self.dataArray[index]
            self.dataArray.remove(at: index)
            self.dataArray.insert(sameModel, at: 0)
        }else {
            self.dataArray.insert(webModel.defaultModel(), at: 0)
        }
        
        self.tableView.reloadData()
        
        AppICloudManager.shared.fetchRemoteIcon(webModel: webModel, completion: { newModel in
            AppICloudManager.shared.saveWebsiteModel(newModel) { [weak self] models in
                self?.dataArray = models
                self?.tableView.reloadData()
            } fail: { error in
                
            }

        })
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        self.view.endEditing(true)
        guard indexPath.section == 1 else {
            return
        }
        
        guard dataArray.count > 0 else {
            return
        }
        
        let webModel = dataArray[indexPath.row]
        self.showTwoAlert(title: webModel.host ?? webModel.dominUrlStr(), message: "Are you sure to select this site?".localStr(), confirm: "YES".localStr(), cancle: "Cancel".localStr()) { [weak self] () in
            self?.onSelectCallBack?(webModel)
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 || self.dataArray.count == 0 {
            return false
        }else{
            return true
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if indexPath.section == 0 || self.dataArray.count == 0 {
            return nil
        }
        
        let model = dataArray[indexPath.row]
        let action1 = UIContextualAction(style: .destructive, title: nil) { [weak self] action, view, finish in
            guard let wSelf = self else { return }
                        
            let alertController: UIAlertController = UIAlertController(title: "Are you sure to delete this site?".localStr(), message: "Once deleted, it can't be recovered.".localStr(), preferredStyle: kaka_IsiPhone() ? .actionSheet : .alert)
            let action1: UIAlertAction = UIAlertAction(title: "Delete".localStr(), style: .destructive) { (sender) in
                wSelf.deleteWebsite(model, indexPath: indexPath)
            }
            
            let action2 : UIAlertAction = UIAlertAction(title: "Cancel".localStr(), style: .cancel) {_ in }
            alertController.addAction(action1)
            alertController.addAction(action2)
            self?.present(alertController, animated: true)
            
        }
        action1.image = Reasource.systemNamed("trash.fill", color: .white)
        action1.backgroundColor = UIColor.systemRed
                
        return UISwipeActionsConfiguration(actions: [action1])
    }
    
    func deleteWebsite(_ model: WebsiteInfoModel, indexPath: IndexPath) {
        MBProgressHUD.showLoading("Please wait".localStr(), inView: self.view)
        AppICloudManager.shared.deleteWebsiteModel(webModel: model) { [weak self] vModel in
            guard let wSelf = self else { return }
            MBProgressHUD.hideLoading(wSelf.view)
            wSelf.dataArray.remove(at: indexPath.row)
            if wSelf.dataArray.count >= 1 {
                wSelf.tableView.deleteRows(at: [indexPath], with: .automatic)
                wSelf.tableView.reloadData()
            }else {
                wSelf.tableView.reloadData()
            }
        } fail: { [weak self] error in
            guard let wSelf = self else { return }
            MBProgressHUD.hideLoading(wSelf.view)
            self?.view.makeToast(error?.localizedDescription)
        }
    }
    
}
