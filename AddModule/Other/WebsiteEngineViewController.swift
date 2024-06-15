//
//  WebsiteEngineViewController.swift
//  PassLock
//
//  Created by Melo on 2023/9/7.
//

import KakaFoundation
import WebKit
import AppGroupKit
import SnapKit
import KakaUIKit

class WebsiteEngineViewController: SuperViewController, UIPopoverPresentationControllerDelegate, UITextFieldDelegate {
    
    private var url: String = ""
    
    init(urlStr: String?, searchKey: String, searchEngine: SearchEngineType?) {
        self.searchKey = searchKey
        self.searchEngine = searchEngine
        self.url = urlStr?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)?.removeSpace() ?? ""
        super.init(nibName: nil, bundle: nil)
    }

    deinit {
         print("### WebsiteEngineViewController ###")
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.url))
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress))
        webView.uiDelegate = nil
        webView.navigationDelegate = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func preSetupSubViews() {
        super.preSetupSubViews()
        
        self.navigationItem.titleView = self.searchField
        
        contentView.addSubview(webView)
        contentView.addSubview(loadActiveView)
        contentView.addSubview(webUrlView)
        webUrlView.addSubview(webUrlLabel)
        
        contentView.bringSubviewToFront(loadActiveView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        webView.frame = contentView.bounds
        
        loadActiveView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            if kaka_IsMacOS() {
                make.top.equalTo(app_navHeight)
            }else{
                make.height.equalTo(2.ckValue())
                make.top.equalTo(app_navHeight)
            }
        }
        
        webUrlView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(webUrlView.size)
            make.bottom.equalToSuperview().inset(kaka_safeAreaInsets().bottom + 15.ckValue())
        }
        
        webUrlLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.size.greaterThanOrEqualTo(0)
        }
    }
    
    override func preSetupHandleBuness() {
        super.preSetupHandleBuness()
        
        self.navigationItem.rightBarButtonItem = self.shareBarItem
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.url), options: .new, context: nil)
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        if let vurl = URL(string: self.url) {
            let request: URLRequest = URLRequest(url: vurl)
            webView.load(request)
        }else{
            
        }
    }

    
    var websiteModel: WebsiteInfoModel? {
        didSet {
            guard let vModel = websiteModel else { return }
            
            let attbuteStr = NSMutableAttributedString()
            
            attbuteStr.append(NSAttributedString(string: "Select current URL".localStr(), attributes: [NSAttributedString.Key.font: UIFontBold(15.ckValue()), NSAttributedString.Key.foregroundColor: UIColor.white]))
            if let domainStr = vModel.host {
                attbuteStr.append(NSAttributedString(string: "\r[\(domainStr)]", attributes: [NSAttributedString.Key.font: UIFontLight(12.ckValue()), NSAttributedString.Key.foregroundColor: UIColor.white]))
            }
            
            self.webUrlLabel.attributedText = attbuteStr
        }
    }
    
    lazy var webView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        let preferences = WKPreferences()
        preferences.isAccessibilityElement = true
        webConfiguration.preferences = preferences
        
        let view = WKWebView(frame: self.view.bounds, configuration: webConfiguration)
        view.scrollView.bounces = true
        view.uiDelegate = self
        view.navigationDelegate = self
        view.allowsBackForwardNavigationGestures = true
        view.scrollView.alwaysBounceVertical = true
        view.scrollView.contentInsetAdjustmentBehavior = .automatic
        return view
    }()
    
    @objc func webUrlButtonClick() {
        guard var website = self.websiteModel else { return }
        website.searchEngine = self.searchEngine
        self.onSelectCallBack?(website)
        self.navigationController?.popViewController(animated: true)
    }
    
    lazy var webUrlLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.textAlignment = .center
        view.textColor = UIColor.label
        view.font = UIFontBold(15.ckValue())
        return view
    }()
    
    lazy var webUrlView: UIView = {
        let colors = [UIColor.systemBlue.cgColor, UIColor.hexColor("#FF00FF").cgColor]

        let view = UIView(frame: CGRectMake(0, 0, self.view.width * (kaka_IsiPad() ? 0.4 : 0.85), 50.ckValue()))
        view.drawHorizontalGradientLayer(colors)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 25.ckValue()
        view.isUserInteractionEnabled = true
        
        view.layer.shadowColor = UIColor.black.withAlphaComponent(0.6).cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = 4
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        let clickTap = UITapGestureRecognizer(target: self, action: #selector(webUrlButtonClick))
        view.addGestureRecognizer(clickTap)
        
        return view
    }()
    
    lazy var searchField: UITextField = {
        
        let leftView = UIView(frame: CGRectMake(0, 0, 40.ckValue(), 20.ckValue()))
        let imgView = UIImageView(image: Reasource.systemNamed("lock.fill", color: .label))
        imgView.frame = CGRectMake(10.ckValue(), 2.5.ckValue(), 15.ckValue(), 15.ckValue())
        leftView.addSubview(imgView)
        
        let view = UITextField(frame: CGRectMake(0, 0, self.view.width * 0.6, 36))
        view.delegate = self
        view.tintColor = appMainColor
        view.returnKeyType = .go
        view.backgroundColor = UIColor.systemFill
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 18
        view.font = UIFontLight(16.ckValue())
        view.textColor = UIColor.label
        view.textAlignment = .left
        view.leftView = leftView
        view.leftViewMode = .always
        view.clearButtonMode = .whileEditing
        return view
    }()
    
    lazy var shareBarItem: UIBarButtonItem = {
        let view = UIBarButtonItem(image: Reasource.systemNamed("safari"), style: .done, target: self, action: #selector(shateButtonClick))
        return view
    }()
    
    @objc func shateButtonClick() {
        guard let currentUrl = URL(string: self.url) else {
            return
        }
        
        UIApplication.shared.open(currentUrl)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let vurl = URL(string: textField.text ?? "") {
            webView.stopLoading()
            let request: URLRequest = URLRequest(url: vurl)
            webView.load(request)
            textField.endEditing(true)
            return true
        }else{
            return false
        }
    }
    
}

extension WebsiteEngineViewController: WKUIDelegate, WKNavigationDelegate {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            DispatchQueue.main.async {[weak self] () in
                guard let wSelf = self else { return }
                wSelf.loadActiveView.alpha = 1
                wSelf.loadActiveView.setProgress(Float((wSelf.webView.estimatedProgress)), animated: true)
            }
            
            if self.webView.estimatedProgress  >= 1.0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] () in
                    self?.loadActiveView.setProgress(0.0, animated: false)
                    self?.loadActiveView.alpha = 0
                }
            }
        }
        
        if keyPath == #keyPath(WKWebView.url) {
            DispatchQueue.main.async { [weak self] () in
                guard let wSelf = self else { return }
                if let newUrl = change?[.newKey] as? URL {
                    guard let urlComponent = URLComponents(url: newUrl, resolvingAgainstBaseURL: true) else {
                        return
                    }
                    
                    let websiteModel = urlComponent.convertWebModel(wSelf.searchKey)
                    wSelf.searchField.text = websiteModel.host
                    wSelf.websiteModel = websiteModel
                }
            }
        }
        
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        self.reloadCount += 1
        
        guard let url = navigationAction.request.url else {
            decisionHandler(.allow)
            return
        }
        
        self.lastUrl = url

        let jumpArray = ["itms-apps", "mailto", "tel"]

        if jumpArray.contains(url.scheme ?? "") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            decisionHandler(.cancel)
        } else {
            if navigationAction.navigationType == .linkActivated {
                DispatchQueue.main.async {
                    webView.load(navigationAction.request)
                }
                decisionHandler(.allow)
            } else {
                if navigationAction.navigationType == .other && self.reloadCount >= 50 {
                    self.handleErrorSearchEngine()
                    decisionHandler(.cancel)
                }else{
                    decisionHandler(.allow)
                }
            }
        }
        
    }
    
    func handleErrorSearchEngine() {
        
        let reason = "Search Enging Error = \(self.searchEngine?.rawValue ?? ""), URL = \(self.url)"
        let feedModel = FeedbackModel(feedbackID: Date().convertString(), type: .searchWebError, content: reason)
        AppICloudManager.shared.addNewFeedBack(model: feedModel)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        debugPrint("❌1 = \(error.localizedDescription)")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        debugPrint("❌2 = \(error.localizedDescription)")
        if error._code == NSURLErrorCancelled {
            return
        }
        
        self.webView.stopLoading()
        
        if let lastUrl = self.lastUrl {
            self.webView.load(URLRequest(url: lastUrl))
        }
    }
    
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!){
        if self.title == "Please wait".localStr() {
            DispatchQueue.main.async {[weak self] () in
                self?.title = ""
            }
        }
    }
    func webViewDidClose(_ webView: WKWebView) {
        
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }
    
}

