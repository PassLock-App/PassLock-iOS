//
//  AddPrivateFileViewController+Scan.swift
//  PassLock
//
//  Created by Melo on 2023/12/26.
//

import KakaFoundation
import KakaUIKit
import VisionKit
import CloudKit
import AppGroupKit

extension AddPrivateFileViewController: VNDocumentCameraViewControllerDelegate {
    func selectImageFromScan() {

        let scanVC = VNDocumentCameraViewController()
        scanVC.delegate = self
        self.present(scanVC, animated: true)
        
    }
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        
        controller.dismiss(animated: true) { [weak self] () in
            guard let wSelf = self else { return }
            
            var leftCount = ...
            leftCount = scan.pageCount > leftCount ? leftCount : scan.pageCount
            
            var tempArray = [SingleFileModel]()
            if let vAssetArr = wSelf.model?.tempAssetArray, vAssetArr.count > 0 {
                tempArray += vAssetArr
            }
            
            for i in 0..<leftCount {
                let image = scan.imageOfPage(at: i)
                if let subModel = SandboxFileManager.shared.saveImageInTempDic(model: wSelf.model!, fileData: image.pngData()) {
                    tempArray.append(subModel)
                }
            }
            
            wSelf.model?.tempAssetArray = tempArray
            wSelf.tableView.reloadData()
        }
        
    }
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        controller.dismiss(animated: true)
        #if DEBUG
        self.view.makeToast(error.localizedDescription)
        #endif
    }
    
    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        controller.dismiss(animated: true)
    }
}
