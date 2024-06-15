//
//  SelectAvatarViewController.swift
//   PassLock
//
//  Created by Melo Dreek on 2023/2/4.
//

import KakaFoundation
import ZLPhotoBrowser
import CloudKit
import MBProgressHUD
import KakaUIKit
import AppGroupKit
import Toast_Swift

class SelectAvatarViewController: SuperViewController {
    
    override func preSetupSubViews() {
        super.preSetupSubViews()
        contentView.addSubview(collectionView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func preSetupHandleBuness() {
        super.preSetupHandleBuness()
        
        for index in 1...14 {
            avatarArray.append("avatar_\(index)")
        }
        
        avatarArray.append("camera_avatar")
        self.collectionView.reloadData()
    }
    
    func selectCustomAvatar(_ user: UserInfoModel) {
        if #available(macCatalyst 14.0, *) {
            ZLPhotoConfiguration.default().useCustomCamera = true
        }else{
            ZLPhotoConfiguration.default().useCustomCamera = false
        }
        
        var editConfig = ZLEditImageConfiguration()
        editConfig = editConfig.clipRatios([.wh1x1])
        
        ZLPhotoConfiguration.default().allowTakePhotoInLibrary = !kaka_IsMacOS()
        ZLPhotoConfiguration.default().maxSelectCount = 1
        ZLPhotoConfiguration.default().allowSelectVideo = false
        ZLPhotoConfiguration.default().allowSelectGif = false
        ZLPhotoConfiguration.default().editAfterSelectThumbnailImage = true
        ZLPhotoConfiguration.default().showClipDirectlyIfOnlyHasClipTool = true
        ZLPhotoUIConfiguration.default().languageType = .system
        ZLPhotoUIConfiguration.default().themeColor = appMainColor
        #if targetEnvironment(macCatalyst)
        ZLPhotoUIConfiguration.default().pri_columnCount = 1
        #endif
        
        ZLPhotoConfiguration.default().editImageConfiguration = editConfig

        let ps = ZLPhotoPreviewSheet()

        ps.selectImageBlock = { [weak self] (results, isOriginal) in
            guard let wSelf = self else { return }
            guard let resultModel: ZLResultModel = results.first else { return }
            
            if userModel.remoteAvatar == nil || userModel.remoteAvatar?.count == 0 {
                userModel.remoteAvatar = CKRecord(recordType: CloudRecordType_RemoteAvatar).recordID.recordName
            }
            
            wSelf.dismiss(animated: false)
            
            guard let avatarAsset = SandboxFileManager.shared.saveAvatarImageSanbox(userModel: userModel, image: resultModel.image) else { return }
            
            let avatarModel = RemoteAvatarModel(cloudUserID: userModel.userID, avatarID: userModel.remoteAvatar ?? "", remote_avatar: avatarAsset)

            MBProgressHUD.showLoading("Please wait".localStr(), inView: wSelf.view)
            AppICloudManager.shared.uploadRemoteAvatar(avatarModel: avatarModel) { avatarID in
                var newModel = userModel
                newModel.localAvatarName = nil
                newModel.remoteAvatar = avatarID
                wSelf.updateAvatar(newModel)
            } fail: { errorMsg in
                MBProgressHUD.hideLoading(wSelf.view)
                wSelf.view.makeToast(errorMsg)
            }
        }
        ps.showPhotoLibrary(sender: self)
    }
    
    // MARK: 🌹 GET && SET 🌹
    
    let itemSpace = 0.0
        
    
    var onUnLoginCallBack: (()->Void)?
    
    var itemWidth: CGFloat {
        get {
            let columnCount: CGFloat = 4.0
            
            let totalW = self.preferredContentSize.width - (columnCount + 1) * itemSpace
            let singleW = totalW / CGFloat(columnCount) - 0.1
            
            return singleW
        }
    }
    
    // MARK: 🌹 Lazy init 🌹
    
    lazy var avatarArray: [String] = {
        return [String]()
    }()
    
    lazy var collectionView: UICollectionView = {
        
        let layout = BaseCollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = itemSpace
        layout.minimumInteritemSpacing = itemSpace
        layout.itemSize = CGSize(width: self.itemWidth, height: self.itemWidth)
        
        let view = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.preferredContentSize.width, height: self.preferredContentSize.height), collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.dataSource = self
        view.delegate = self
        view.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
        view.showsHorizontalScrollIndicator = false
        view.register(SelectAvatarViewCell.self, forCellWithReuseIdentifier: "SelectAvatarViewCell")
        view.dataSource = self
        view.delegate = self
        view.semanticContentAttribute = PhoneSetManager.isArabicLanguage() ? UISemanticContentAttribute.forceRightToLeft : UISemanticContentAttribute.forceLeftToRight
        view.alwaysBounceVertical = true
        return view
    }()
    
}

extension SelectAvatarViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return avatarArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectAvatarViewCell", for: indexPath) as! SelectAvatarViewCell
        let iconName = avatarArray[indexPath.row]
        let isLastCell = avatarArray.count - 1 == indexPath.row
        cell.avatarView.image = Reasource.named(iconName)
        cell.avatarView.backgroundColor = isLastCell ? appMainColor : UIColor.clear
        cell.avatarView.layer.masksToBounds = isLastCell
        cell.avatarView.layer.cornerRadius = isLastCell ? self.itemWidth * 0.3 : 0
        cell.avatarView.snp.remakeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(isLastCell ? 5 : 0)
            make.size.equalToSuperview().multipliedBy(isLastCell ? 0.6 : 0.8)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row == avatarArray.count - 1 {
            self.selectCustomAvatar(userModel)
        }else{
            let iconName = self.avatarArray[indexPath.row]
            self.dismiss(animated: false)
            
            AppICloudManager.shared.deleteRemoteAvatar(userModel: model) {
                
                model.localAvatarName = iconName
                model.remoteAvatar = nil
                self.updateAvatar(model)
            } fail: { errorMsg in
                
                model.localAvatarName = iconName
                model.remoteAvatar = nil
                self.updateAvatar(model)
            }

        }
    }

}
