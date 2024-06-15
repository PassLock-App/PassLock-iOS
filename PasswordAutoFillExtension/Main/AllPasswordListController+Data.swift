//
//  AllPasswordListController+Data.swift
//  PasswordAutoFillExtension
//
//  Created by Melo on 2023/12/2.
//

import KakaFoundation
import AppGroupKit


extension AllPasswordListController: UITableViewDataSource, UITableViewDelegate, UIPopoverPresentationControllerDelegate {
    
    func refreshDataAction() {
                        
        let userModel = ...
        var allPassArray = [PrivateBaseItemModel]()

        let recordArray: [AppRecordType] = [.defaultBook, .familyBook, .companyBook, .otherBook]
        
        for subType in recordArray {
            let cacheKey = (subType.rawValue + "_" + (userModel?.userID ?? "")).sha256()
            
            let encodeStr = self.sharedUD.string(forKey: cacheKey) ?? ""
            let jsonStr = CryptoHelper.decryptAES(string: encodeStr, key: ...)
            let passArray = [PrivateBaseItemModel].deserialize(from: jsonStr)?.compactMap({ $0 }) ?? []
            
            allPassArray += passArray
        }
        
        self.resortDataSource(allPassArray)
        
    }
    
    func resortDataSource(_ tempAllArray: [PrivateBaseItemModel]) {
                
        self.originDataArray = tempAllArray
        self.searchController.originDataArray = tempAllArray
        
        let allSortedArray = tempAllArray.sorted { model1, model2 in
            if let date1 = model1.modifyDate, let date2 = model2.modifyDate {
                return date1 > date2
            } else if model1.modifyDate != nil {
                return true
            } else {
                return false
            }
        }
        
        var groupedDictionary = [String: [PrivateBaseItemModel]]()
        
        for accountModel in allSortedArray {
            
            let firstLetter = accountModel.firstChar()
            
            if groupedDictionary[firstLetter] == nil {
                groupedDictionary[firstLetter] = [PrivateBaseItemModel]()
            }
            
            groupedDictionary[firstLetter]?.append(accountModel)
        }
        
        let sectionTitles = UILocalizedIndexedCollation.current().sectionTitles
        
        let sortedDictory = groupedDictionary.sorted { element1, element2 in
            guard let index1 = sectionTitles.firstIndex(of: element1.key), let index2 = sectionTitles.firstIndex(of: element2.key) else {
                return false
            }
            
            return index1 < index2
        }
        
        var indexArr = sortedDictory.map({ $0.key })
        
        let starArray = allSortedArray.filter { $0.isCollection == true }
        if (starArray.count > 0) {
            indexArr.insert("★", at: 0)
            groupedDictionary["★"] = starArray
        }
        
        var recommentArray = [PrivateBaseItemModel]()
        for domin in self.dominArray {
            let subArr = allSortedArray.filter {
                $0.searchMatcheItem(domin)
            }
                        
            recommentArray += subArr
        }
        
        if recommentArray.count > 0 {
            indexArr.insert("♣︎", at: 0)
            groupedDictionary["♣︎"] = recommentArray
        }
        
        self.indexArray = indexArr
        self.dataDictionary = groupedDictionary
        self.tableView.reloadData()
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return indexArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dataArray = self.dataArray(section)
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        let dataArray = self.dataArray(indexPath.section)
        
        let model = dataArray[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PassbookTableExtensionCell", for: indexPath) as! PassbookTableExtensionCell
        cell.update(model: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let dataArray = self.dataArray(indexPath.section)
        
        let model = dataArray[indexPath.row]
        
        if model.passwordModel?.passwords?.count == 1 {
            guard let accountName = model.passwordModel?.accountName, let passwordModel = model.passwordModel?.passwords?.first else { return }

            self.delegate?.passwordControllerDidSelect(controller: self, account: accountName, passModel: passwordModel)
        }else{
            let detialVC = PasswordDetialExtensionController(model: model)
            detialVC.onSelectCallBack = { [weak self] (account, model) in
                guard let wSelf = self else { return }
                wSelf.delegate?.passwordControllerDidSelect(controller: wSelf, account: account, passModel: model)
            }
            self.navigationController?.pushViewController(detialVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let title = indexArray[section]
        return title == "♣︎" ? (self.dominArray.first ?? "Associated Passwords".localStr()) : title
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.indexArray
    }
    
}
