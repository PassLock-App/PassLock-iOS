//
//  LoginViewController.swift
//  PassLock
//
//  Created by Melo on 2024/5/28.
//

import KakaFoundation
import KakaUIKit
import YYText
import AppGroupKit
import SafariServices
import CloudKit


class LoginViewController: SuperViewController {
    
    override func preSetupSubViews() {
        super.preSetupSubViews()
        contentView.addSubview(collectionView)
        contentView.addSubview(pageControl)
        contentView.addSubview(pleaseLabel)
        contentView.addSubview(proButton)
        contentView.addSubview(messageLabel)
        contentView.addSubview(signButton)
        contentView.addSubview(privacyLabel)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        pleaseLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(50.ckValue())
            make.size.greaterThanOrEqualTo(0)
        }
        
        proButton.snp.makeConstraints { make in
            make.centerY.equalTo(pleaseLabel.snp.top)
            make.width.equalTo(40.ckValue())
            make.centerX.equalTo(pleaseLabel.snp.trailing)
            make.height.equalTo(25.ckValue())
        }
        
        messageLabel.snp.makeConstraints { make in
            make.leading.equalTo(40.ckValue())
            make.top.equalTo(pleaseLabel.snp.bottom).offset(15.ckValue())
            make.centerX.equalToSuperview()
            make.height.greaterThanOrEqualTo(0)
        }
        
        signButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.85)
            make.height.equalTo(signButton.layer.cornerRadius * 2)
            make.bottom.equalToSuperview().inset(kaka_safeAreaInsets().bottom + 45.ckValue())
        }
        
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(signButton.snp.top).offset(-15.ckValue())
            make.size.greaterThanOrEqualTo(0)
        }
        
        privacyLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(kaka_safeAreaInsets().bottom / 2 + 15.ckValue())
            make.leading.equalToSuperview().offset(20.ckValue())
            make.height.greaterThanOrEqualTo(0)
        }
        
        self.flowLayout.itemSize = windowSizee
        self.collectionView.reloadData()
    }
    
    override func preSetupHandleBuness() {
        super.preSetupHandleBuness()
                
        self.navigationItem.largeTitleDisplayMode = .never
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func dismissAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK:  GET && SET
            
    var currentIndex: Int = 0
        
    var windowSizee: CGSize {
        get {
            let size = self.view.bounds.size
            return size
        }
    }
    
    let dataArray: [WelcomeInfoModel] = WelcomeInfoModel().welcomeDataArray()
    
    // MARK:  Lazy init
    
    lazy var purchaseManager: KakaAppStoreManager = {
        return KakaAppStoreManager()
    }()
    
    lazy var signButton: UIButton = {
        let view = UIButton(type: .custom)
        view.titleLabel?.font = UIFontBold(16.ckValue())
        view.setTitleColor(.white, for: .normal)
        view.setTitle("Sign in with iCloud".localStr(), for: .normal)
        view.backgroundColor = UIColor.black
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 22.5.ckValue()
        view.addTarget(self, action: #selector(signinButtonClick), for: .touchUpInside)
        return view
    }()
    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.backgroundColor = .clear
        view.dataSource = self
        view.delegate = self
        view.isPagingEnabled = true
        view.bounces = false
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.alwaysBounceVertical = true
        view.contentInsetAdjustmentBehavior = .never
        view.semanticContentAttribute = PhoneSetManager.isArabicLanguage() ? UISemanticContentAttribute.forceRightToLeft : UISemanticContentAttribute.forceLeftToRight
        view.register(LoginCollectionCell.self, forCellWithReuseIdentifier: "LoginCollectionCell")
        return view
    }()
    
    lazy var flowLayout: BaseCollectionViewFlowLayout = {
        let layout = BaseCollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = windowSizee
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        return layout
    }()
    
    lazy var pageControl: UIPageControl = {
        let view = UIPageControl()
        view.currentPageIndicatorTintColor = UIColor.black
        view.pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.5)
        view.currentPage = currentIndex
        view.numberOfPages = dataArray.count
        return view
    }()
    
    lazy var pleaseLabel: UILabel = {
        let view = UILabel()
        view.text = "Cloud Vault".localStr()
        view.font = UIFontBold(30.ckValue())
        view.textAlignment = .center
        view.textColor = UIColor.black
        return view
    }()
    
    lazy var messageLabel: UILabel = {
        let view = UILabel()
        view.text = "Login to the Cloud Vault and you won't have to worry about losing your data, even if you change devices.".localStr()
        view.numberOfLines = 0
        view.textColor = UIColor.black.withAlphaComponent(0.8)
        view.font = UIFontBold(16.ckValue())
        view.textAlignment = pleaseLabel.textAlignment
        return view
    }()
    
    lazy var proButton: UIButton = {
        let view = UIButton(type: .custom)
        view.backgroundColor = UIColor.rgb(255, 165, 0)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 6.ckValue()
        view.isUserInteractionEnabled = false
        view.setTitle("Pro", for: .normal)
        view.titleLabel?.font = UIFontBold(16.ckValue())
        view.setTitleColor(.black, for: .normal)
        return view
    }()
    
    lazy var privacyLabel: YYLabel = {
        let text1 = "Privacy Policy".localStr()
        let text2 = "Terms of Service".localStr()
        
        let sumText = String(format: "Continuing means you have agreed to %@ and %@".localStr(), text1, text2)
        let range1 = sumText.ocString.range(of: text1)
        let range2 = sumText.ocString.range(of: text2)
        
        let color = UIColor.black.withAlphaComponent(0.8)
        let titleAttbuteStr = NSMutableAttributedString(string: sumText, attributes: [NSAttributedString.Key.font: UIFontLight(12.ckValue()), NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.underlineColor: color])
        titleAttbuteStr.yy_alignment = .center
        titleAttbuteStr.yy_setUnderlineStyle(.single, range: range1)
        titleAttbuteStr.yy_setUnderlineStyle(.single, range: range2)
        titleAttbuteStr.yy_setUnderlineColor(UIColor.black, range: range1)
        titleAttbuteStr.yy_setUnderlineColor(UIColor.black, range: range2)
        titleAttbuteStr.yy_setTextHighlight(range1, color: UIColor.black, backgroundColor: nil) { [weak self] (view, attr, range, rect) in
            guard let wSelf = self else { return }
            guard let vUrl = URL(string: kPrivacyUrl) else { return }
            
            if kaka_IsMacOS() {
                UIApplication.shared.open(vUrl, options: [:], completionHandler: nil)
            }else{
                let webVC = SFSafariViewController(url: vUrl)
                webVC.preferredControlTintColor = appMainColor
                wSelf.present(webVC, animated: true)
            }
        }
        titleAttbuteStr.yy_setTextHighlight(range2, color: UIColor.black, backgroundColor: nil) { [weak self] (view, attr, range, rect) in
            guard let wSelf = self else { return }
            guard let vUrl = URL(string: kUseItemUrl) else { return }
            
            if kaka_IsMacOS() {
                UIApplication.shared.open(vUrl, options: [:], completionHandler: nil)
            }else{
                let webVC = SFSafariViewController(url: vUrl)
                webVC.preferredControlTintColor = appMainColor
                wSelf.present(webVC, animated: true)
            }
        }
        
        let view = YYLabel()
        view.numberOfLines = 0
        view.attributedText = titleAttbuteStr
        view.preferredMaxLayoutWidth = self.view.width * 0.85
        return view
    }()
    
}

extension LoginViewController: UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LoginCollectionCell", for: indexPath) as! LoginCollectionCell
        cell.model = dataArray[indexPath.section]
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        var page = Int(round(offset.x / flowLayout.itemSize.width))
        page = max(0, min(page, dataArray.count - 1))

        self.currentIndex = page
        
        pageControl.currentPage = page
    }
    
}

