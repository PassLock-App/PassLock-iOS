//
//  GroupSingleAssetView.swift
//  PassLock
//
//  Created by Melo on 2024/1/12.
//

import KakaFoundation
import KakaUIKit
import AppGroupKit

class GroupSingleAssetView: UIView, UICollectionViewDataSource, UICollectionViewDelegate {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.preSetupSubViews()
        self.preSetupContains()
        self.preSetupHandleBuness()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func preSetupSubViews() {
        self.addSubview(emptyIconView)
        self.addSubview(collectionView)
    }
    
    private func preSetupContains() {
        emptyIconView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalTo(emptyIconView.snp.height)
        }
        
    }
    
    private func preSetupHandleBuness() {
        self.backgroundColor = .random()
    }
    
    // MARK: 🌹 GET && SET 🌹
    var model: PrivateBaseItemModel? {
        didSet {
            let isHasAsset = (model?.assetIdArray?.count ?? 0) > 0
            emptyIconView.isHidden = isHasAsset
            collectionView.isHidden = !isHasAsset
            self.collectionView.reloadData()
        }
    }
    
    // MARK: 🌹 Lazy init 🌹
    lazy var flowLayout: BaseCollectionViewFlowLayout = {
        let space: Double = 1.ckValue()
        let layout = BaseCollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = space
        layout.minimumInteritemSpacing = space
        
        let itemWidth = (self.bounds.width - space * 2) / 3
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        return layout
    }()
    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: self.bounds, collectionViewLayout: self.flowLayout)
        view.backgroundColor = .clear
        view.dataSource = self
        view.delegate = self
        view.showsHorizontalScrollIndicator = false
        view.alwaysBounceVertical = true
        view.semanticContentAttribute = PhoneSetManager.isArabic() ? UISemanticContentAttribute.forceRightToLeft : UISemanticContentAttribute.forceLeftToRight
        view.register(SingleAssetViewCell.self, forCellWithReuseIdentifier: "SingleAssetViewCell")
        return view
    }()
    
    lazy var emptyIconView: UIImageView = {
        let view = UIImageView(image: KakaReasource.named("kaka_ops_404@3x.png"))
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.model?.assetIdArray?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SingleAssetViewCell", for: indexPath) as! SingleAssetViewCell
        if let vModel = self.model, let assetIdArray = vModel.assetIdArray, assetIdArray.count > 0 {
            let assetId = assetIdArray[indexPath.row]
            cell.updateRemote(recordType: vModel.recordType, recordID: assetId)
        }
        return cell
    }
    
}
