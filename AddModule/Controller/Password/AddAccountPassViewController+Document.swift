//
//  AddAccountPassViewController+Document.swift
//  PassLock
//
//  Created by Melo Dreek on 2023/5/16.
//

import KakaFoundation
import KakaUIKit
import CloudKit
import AppGroupKit

extension AddAccountPassViewController: UIDocumentPickerDelegate {
    
    func selectFileFromDocument() {
        
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.image, .tiff, .jpeg, .livePhoto, .bmp, .ico, .icns, .gif], asCopy: true)
        
        documentPicker.delegate = self
        documentPicker.shouldShowFileExtensions = true
        documentPicker.allowsMultipleSelection = false
        self.present(documentPicker, animated: true, completion: nil)
        
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        var tempArray = [SingleFileModel]()
        if let vModel = self.model, let assets = vModel.tempAssetArray, assets.count > 0 {
            tempArray += assets
        }
        
        urls.forEach { subUrl in
            let asset = CKAsset(fileURL: subUrl)
            if let subModel = SandboxFileManager.shared.saveImageInTempDic(model: self.model!, fileData: asset.originFileData()) {
                tempArray.append(subModel)
            }
        }
        
        self.model?.tempAssetArray = tempArray
        
        self.tableView.reloadData()
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("Document picker was cancelled")
    }
    
}
