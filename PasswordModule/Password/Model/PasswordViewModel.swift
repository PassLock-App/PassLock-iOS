//
//  PasswordViewModel.swift
//   PassLock
//
//  Created by Melo Dreek on 2023/3/18.
//  Copyright © 2023 PassLock. All rights reserved.
//

import KakaFoundation
import CloudKit
import AppGroupKit

class PasswordViewModel {
    
    init(_ itemType: StorageItemType) {
        self.itemType = itemType
    }
    
    var cloudStatus = CloudAccountStatus.networkUnable
    
    var itemType: StorageItemType = .allItem
    
    var syncStatus: SyncCloudStatus? {
        get {
                        
            guard originDataArray.count > 0 else { return nil }
            
            if self.isSyncing { return .syncing }
            
            let sumCount = originDataArray.count
            let syncCount = originDataArray.filter { $0.isSyncCloud }.count
            
            if sumCount == syncCount {
                return .completion
            }
            
            if syncCount < sumCount && syncCount > 0 {
                return .warning
            }
            
            if syncCount == 0 {
                return .unScyn
            }
                        
            return nil
        }
    }
    
    var isSyncing: Bool = false
    
    var originDataArray: [PrivateBaseItemModel] = [] {
        didSet {
            
            var tempAllArray = originDataArray
            
            tempAllArray = tempAllArray.sorted { model1, model2 in
                if let date1 = model1.modifyDate, let date2 = model2.modifyDate {
                    return date1 > date2
                } else if model1.modifyDate != nil {
                    return true
                } else {
                    return false
                }
            }
            
            
            if (self.healthRisk != .allData) {
                tempAllArray = self.groupSorted(self.healthRisk)
            }
        
            var groupedDictionary = [String: [PrivateBaseItemModel]]()
            
            for accountModel in tempAllArray {
                
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
            
            let starArray = tempAllArray.filter { $0.isCollection == true }
            if (starArray.count > 0) {
                indexArr.insert("★", at: 0)
                groupedDictionary["★"] = starArray
            }
            self.indexArray = indexArr
            
            self.dataDictionary = groupedDictionary
        }
    }
    
    public func groupSorted(_ healthRisk: PassHealthRick) -> [PrivateBaseItemModel] {
        let tempAllArray = self.originDataArray.filter { $0.storageType == .password }
        
        if (healthRisk == .easyGuess) {
            weakPassArray = tempAllArray.filter { $0.isWeakPassword() }
            return weakPassArray
        }else if healthRisk == .securety {
            safePassArray = tempAllArray.filter { !$0.isWeakPassword() }
            return safePassArray
        }else if healthRisk == .duplicate {
            var duplicatePassArray = [PrivateBaseItemModel]()
            
            for i in 0..<tempAllArray.count {
                let currentModel = tempAllArray[i]
                let currentPassword = currentModel.passwordModel?.passwords?.first?.password ?? ""
                
                for j in (i+1)..<tempAllArray.count {
                    let compareModel = tempAllArray[j]
                    let comparePassword = compareModel.passwordModel?.passwords?.first?.password ?? ""
                    
                    if currentPassword == comparePassword {
                        duplicatePassArray.append(compareModel)
                        duplicatePassArray.append(currentModel)
                        break
                    }
                }
            }
            
            self.duplicatePassArray = duplicatePassArray
            return duplicatePassArray

        }else{
            return tempAllArray
        }
        
    }
    
    func sortHealthDataSource(_ model: PrivateBaseItemModel) -> [PassHealthRick] {
        
        let safeArray = self.safePassArray.filter { $0.recordId == model.recordId }
        if safeArray.count > 0 {
            return [.securety]
        }else{
            let repeatArray = self.duplicatePassArray.filter {
                $0.recordId == model.recordId
            }
            let weakArray = self.weakPassArray.filter {
                $0.recordId == model.recordId
            }
            
            if repeatArray.count > 0 && weakArray.count > 0 {
                return [.duplicate, .easyGuess]
            } else {
                return repeatArray.count > 0 ? [.duplicate] : [.easyGuess]
            }
            
        }
        
    }
    
    var healthRisk: PassHealthRick = .allData
    
    public var indexArray: [String] = [String]()
    
    private (set) var duplicatePassArray: [PrivateBaseItemModel] = []
    private (set) var weakPassArray: [PrivateBaseItemModel] = []
    private (set) var safePassArray: [PrivateBaseItemModel] = []
    
    public func dataArray(_ index: Int) -> [PrivateBaseItemModel] {
        let key = self.indexArray[index]
        let dataArr = self.dataDictionary[key] ?? []
        return dataArr
    }
    
    private (set) var dataDictionary: [String: [PrivateBaseItemModel]] = [:]
    
}
