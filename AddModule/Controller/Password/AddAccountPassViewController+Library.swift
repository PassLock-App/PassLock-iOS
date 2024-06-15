//
//  AddAccountPassViewController+Library.swift
//  PassLock
//
//  Created by Melo Dreek on 2023/5/30.
//

import KakaFoundation
import ZLPhotoBrowser
import CloudKit
import Photos
import KakaUIKit
import AppGroupKit
import Toast_Swift


extension AddAccountPassViewController {
    
    func selectImageFromLibrary() {
                
        ZLPhotoConfiguration.default().useCustomCamera = true
        ZLPhotoConfiguration.default().allowTakePhotoInLibrary = !kaka_IsMacOS()
        ZLPhotoConfiguration.default().maxSelectCount = kPasswordFileMaxCount - (self.model?.tempAssetArray?.count ?? 0)
        ZLPhotoConfiguration.default().allowSelectVideo = false
        
        ZLPhotoUIConfiguration.default().languageType = .system
        ZLPhotoUIConfiguration.default().themeColor = appMainColor

        let ps = ZLPhotoPreviewSheet()

        ps.selectImageBlock = { [weak self] (results, isOriginal) in
            self?.handleSelectImages(results)
        }
        ps.showPhotoLibrary(sender: self)
    }
    
    func handleSelectImages(_ results: [ZLResultModel]) {
        
        var tempArray = [SingleFileModel]()
        if let vModel = self.model, let assets = vModel.tempAssetArray, assets.count > 0 {
            tempArray += assets
        }
        
        let fetchDataGroup = DispatchGroup()
        results.forEach { [weak self] subModel in
            fetchDataGroup.enter()
            
            let option = PHContentEditingInputRequestOptions()
            option.isNetworkAccessAllowed = true
            subModel.asset.requestContentEditingInput(with: option) { [weak self] contentEditingInput, info in
                guard let pathURL = contentEditingInput?.fullSizeImageURL else {
                    self?.view.makeToast("NULL Image Path")
                    fetchDataGroup.leave()
                    return
                }
                                
                let indexAsset = CKAsset(fileURL: pathURL)
                if let imageData = indexAsset.originFileData() {
                    if let subModel = SandboxFileManager.shared.saveImageInTempDic(model: self!.model!, fileData: imageData) {
                        tempArray.append(subModel)
                    }
                }
                
                fetchDataGroup.leave()
            }
        }
        
        fetchDataGroup.notify(queue: .main) { [weak self] () in
            self?.model?.tempAssetArray = tempArray
            self?.tableView.reloadData()
            
            self?.deletePhoto(results)
        }
            
    }
    
    func deletePhoto(_ results: [ZLResultModel]) {
        let identifiers = results.map { $0.asset.localIdentifier }
        
        PHPhotoLibrary.shared().performChanges {
            let result = PHAsset.fetchAssets(withLocalIdentifiers: identifiers, options: nil)
            PHAssetChangeRequest.deleteAssets(result)
        } completionHandler: { finish, error in
            if finish {
                DispatchQueue.main.sync {
                    self.view.makeToast("Delete Successful".localStr())
                }
            }
        }

    }
    
}
