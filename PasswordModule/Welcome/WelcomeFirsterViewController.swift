//
//  WelcomeFirsterViewController.swift
//   PassLock
//
//  Created by Melo Dreek on 2023/3/18.
//  Copyright © 2023 PassLock. All rights reserved.
//

import KakaUIKit
import KakaFoundation
import KakaObjcKit
import AppGroupKit
import JXPageControl
import CryptoKit
import Reachability
import SafariServices
import YYText


class WelcomeFirsterViewController: SuperViewController, UIWindowSceneDelegate {
    
    override func preSetupSubViews() {
        super.preSetupSubViews()
        self.view.backgroundColor = UIColor.rgb(49, 54, 87)
        let colors = [UIColor.rgb(60, 66, 107).cgColor, UIColor.rgb(49, 54, 87).cgColor]
        self.view.drawVerticalGradientLayer(colors)
        contentView.backgroundColor = UIColor.clear
        
        contentView.addSubview(collectionView)
        contentView.addSubview(privacyLabel)
        contentView.addSubview(pageControl)
        contentView.addSubview(arabicPageControl)
        contentView.addSubview(signinButton)
        contentView.addSubview(nextButton)
        contentView.addSubview(skipButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        privacyLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(kaka_safeAreaInsets().bottom / 2 + 15.ckValue())
            make.leading.equalToSuperview().offset(20.ckValue())
            make.height.greaterThanOrEqualTo(0)
        }
        
        signinButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.85)
            make.height.equalTo(50.ckValue())
            make.bottom.equalTo(privacyLabel.snp.top).offset(-12.ckValue())
        }
        
        nextButton.snp.makeConstraints { make in
            make.edges.equalTo(signinButton)
        }
        
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(signinButton.snp.top).offset(-15.ckValue())
            make.size.greaterThanOrEqualTo(0)
        }
        
        arabicPageControl.snp.makeConstraints { make in
            make.edges.equalTo(pageControl)
        }
        
        skipButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(30.ckValue())
            make.top.equalToSuperview().offset(kStatusBarHeight / 2 + 30.ckValue())
            make.size.greaterThanOrEqualTo(0)
        }
        
        self.flowLayout.itemSize = self.windowSizee
        self.collectionView.reloadData()
    }
    
    override func preSetupHandleBuness() {
        super.preSetupHandleBuness()
                
        
        self.scrollViewDidScroll(self.collectionView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
                
        self.fetchNetworkApi()

        try? self.reachability.startNotifier()
    }
    
    @objc func reachabilityChanged(note: Notification) {
                
        guard let reachability = note.object as? Reachability else { return }
        
        debugPrint("Current Network = \(reachability.connection.description)")
        
        self.netConnect = reachability.connection
        
        if reachability.connection == .unavailable {
            return
        }
        
        self.fetchNetworkApi()
        
    }
    
    @objc func fetchNetworkApi() {
        let firstModel = FeedbackModel(feedbackID: KakaUDID.value(), type: .firstLaunch, content: "First Lanugh")
        AppICloudManager.shared.addNewFeedBack(model: firstModel)
        
        
    }
    
    @objc func contactDevButtonClick() {
        let developerVC = TransparencyViewController()
        self.present(KakaNavigationController(rootViewController: developerVC), animated: true)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc func continueButtonClick() {
        guard var indexPath = self.collectionView.indexPathsForVisibleItems.first else {
            return
        }
        
        if indexPath.section >= self.dataArray.count - 1 {
            self.nextButton.isHidden = true
            self.signinButton.isHidden = false
            return
        }
        
        self.nextButton.isHidden = false
        self.signinButton.isHidden = true
        indexPath = IndexPath(row: 0, section: indexPath.section + 1)
        
        self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    // MARK: 🌹 GET && SET 🌹
    var onLoginSuccessCallBack: (()->Void)?
    
    var windowSizee: CGSize {
        get {
            let size = UIApplication.shared.windows.first?.frame.size ?? self.view.bounds.size
            return size
        }
    }
    
    var netConnect: Reachability.Connection = .unavailable
    var tokenRetryCount: Int = 0
    
    lazy var reachability: Reachability = {
        return try! Reachability()
    }()
    
    var currentIndex: Int = 0 {
        didSet {
            let isLast = dataArray.count - 1 == currentIndex
            self.nextButton.isHidden = isLast
            self.signinButton.isHidden = !isLast
        }
    }
    
    var dataArray: [WelcomeInfoModel] {
        get {
            return WelcomeInfoModel().welcomeDataArray()
        }
    }
    
    // MARK: 🌹 Lazy init 🌹
    
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
        view.semanticContentAttribute = PhoneSetManager.isArabicLanguage() ? UISemanticContentAttribute.forceRightToLeft : UISemanticContentAttribute.forceLeftToRight
        view.register(WelcomeCollectCell.self, forCellWithReuseIdentifier: "WelcomeCollectCell")
        return view
    }()
    
    lazy var flowLayout: BaseCollectionViewFlowLayout = {
        let layout = BaseCollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = self.windowSizee
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        return layout
    }()
    
    lazy var nextButton: UIButton = {
        let view = UIButton(type: .custom)
        view.backgroundColor = UIColor.black
        view.layer.masksToBounds = true
        view.layer.cornerRadius = signinButton.layer.cornerRadius
        view.setTitle("Next".localStr(), for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.titleLabel?.font = UIFontBold(17.ckValue())
        view.addTarget(self, action: #selector(continueButtonClick), for: .touchUpInside)
        return view
    }()
    
    lazy var signinButton: UIButton = {
        let view = UIButton(type: .custom)
        view.isHidden = true
        view.backgroundColor = UIColor.black
        view.layer.cornerRadius = 12.ckValue()
        view.setTitle("Continue".localStr(), for: .normal)
        view.titleLabel?.font = UIFontBold(17.ckValue())
        view.setTitleColor(.white, for: .normal)
        view.addTarget(self, action: #selector(signinWithAppleID), for: .touchUpInside)
        return view
    }()
    
    lazy var skipButton: UIButton = {
        let view = UIButton()
        view.isHidden = privacyLabel.isHidden
        view.setTitle("skip".localStr(), for: .normal)
        view.titleLabel?.font = UIFontBold(15.ckValue())
        view.setTitleColor(UIColor.black, for: .normal)
        view.addTarget(self, action: #selector(skipButtonClick), for: .touchUpInside)
        return view
    }()
    
    @objc func skipButtonClick() {
        self.collectionView.scrollToItem(at: IndexPath(row: 0, section: dataArray.count - 1), at: .centeredHorizontally, animated: true)
    }
    
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
    
    lazy var pageControl: JXPageControlScale = {
        let view = JXPageControlScale()
        view.isHidden = PhoneSetManager.isArabicLanguage()
        view.contentMode = .bottom
        view.activeSize = CGSize(width: 15.ckValue(), height: 6.ckValue())
        view.inactiveSize = CGSize(width: 6.ckValue(), height: 6.ckValue())
        view.activeColor = UIColor.black
        view.inactiveColor = UIColor.black.withAlphaComponent(0.6)
        view.columnSpacing = 0
        view.isAnimation = true
        view.numberOfPages = dataArray.count
        return view
    }()
    
    lazy var arabicPageControl: UIPageControl = {
        let view = UIPageControl()
        view.currentPageIndicatorTintColor = pageControl.activeColor
        view.pageIndicatorTintColor = pageControl.inactiveColor
        view.isHidden = !PhoneSetManager.isArabicLanguage()
        view.currentPage = currentIndex
        view.numberOfPages = dataArray.count
        return view
    }()
}

extension WelcomeFirsterViewController: UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WelcomeCollectCell", for: indexPath) as! WelcomeCollectCell
        cell.model = dataArray[indexPath.section]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        #if DEBUG && targetEnvironment(macCatalyst)
//        self.dismissAnimation()
//        #endif
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        var page = Int(round(offset.x / flowLayout.itemSize.width))
        page = max(0, min(page, dataArray.count - 1))

        self.currentIndex = page
        
        pageControl.currentPage = page
        arabicPageControl.currentPage = page
    }
    
}

