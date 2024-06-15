//
//  SearchEngineHeadCell.swift
//  PassLock
//
//  Created by Melo on 2023/9/7.
//

import KakaFoundation
import KakaUIKit
import HandyJSON
import AppGroupKit

class SearchEngineHeadCell: UITableViewCell, UIPopoverPresentationControllerDelegate {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.accessoryType = .none
        self.backgroundColor = .clear
        
        self.preInitSubView()
        self.preInitFrames()
        self.preHandleBuness()
    }
    
    func preInitSubView() {
        contentView.addSubview(searchIconImgView)
        contentView.addSubview(switchEngineBtn)
        contentView.addSubview(clickControl)
        contentView.addSubview(searchView)
        
        searchView.addSubview(searchButton)
        searchView.addSubview(searchField)
    }
    
    func preInitFrames() {
        
        let iconValue = searchIconImgView.image!.size.width / searchIconImgView.image!.size.height
        
        searchIconImgView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15.ckValue())
            make.centerX.equalToSuperview()
            make.height.equalTo(60.ckValue())
            make.width.equalTo(searchIconImgView.snp.height).multipliedBy(iconValue)
        }
        
        switchEngineBtn.snp.makeConstraints { make in
            make.centerY.equalTo(searchIconImgView)
            make.leading.equalTo(searchIconImgView.snp.trailing).offset(5.ckValue())
            make.size.equalTo(34.ckValue())
        }
        
        clickControl.snp.makeConstraints { make in
            make.leading.top.bottom.equalTo(searchIconImgView)
            make.trailing.equalTo(switchEngineBtn)
        }
        
        searchView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15.ckValue())
            make.top.equalTo(searchIconImgView.snp.bottom).offset(20.ckValue())
            make.height.equalTo(searchView.layer.cornerRadius * 2)
            make.bottom.equalToSuperview().inset(20.ckValue())
        }
        
        searchButton.snp.makeConstraints { make in
            make.trailing.bottom.top.equalToSuperview()
            make.width.equalTo(searchButton.size.width)
        }
        
        searchField.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.trailing.equalTo(searchButton.snp.leading)
        }
        
    }
    
    func preHandleBuness() {
        let placeAttbute = NSAttributedString(string: "Please enter keywords".localStr(), attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.ckValue()), NSAttributedString.Key.foregroundColor: UIColor.gray])
        self.searchField.attributedPlaceholder = placeAttbute
        
        if let lastEngine = AppLocalManager.shared.lastSearchEngine {
            self.searchEngine = lastEngine
        }else{
            let country = PhoneSetManager.localPhoneCountry()
            var engine = SearchEngineType.google
            switch country {
            case .chinese:
                engine = .bing
            case .japanese:
                engine = .yahooJapan
            case .korea:
                engine = .naver
            case .russian:
                engine = .yandex
            default:
                engine = .google
            }
            
            self.searchEngine = engine
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func pushHtmlController(_ tagText: String)  {
        
        self.endEditing(true)
        
        self.searchField.text = tagText
        
        let searchUrl = String(format: self.searchEngine.searchUrl(), tagText)
        self.onSearchCallBack?(searchUrl, tagText, searchEngine)
    }
    
    // MARK: 🌹 SET && GET 🌹
    var searchEngine: SearchEngineType! {
        didSet {
            let image = Reasource.named(searchEngine.rawValue)
            searchIconImgView.image = image
        }
    }
    
    var onSearchCallBack: ((String, String, SearchEngineType)->Void)?
    
    
    var onVIPCallBack: (()->Void)?
    
    
    var onSelectCallBack: ((WebsiteInfoModel)->Void)?
    
    @objc func selectSearchEngine() {
        let engineVC = SelectEnginePopController()
        engineVC.onSelectCallBack = { [weak self] (engine) in
            self?.searchEngine = engine
        }
        engineVC.preferredContentSize = CGSize(width: 300.ckValue(), height: 60.ckValue() * 5)
        engineVC.modalPresentationStyle = .popover
        let popVC = engineVC.popoverPresentationController
        popVC?.delegate = self
        popVC?.backgroundColor = UIColor.clear
        popVC?.permittedArrowDirections = .up
        popVC?.sourceRect = self.searchIconImgView.bounds
        popVC?.sourceView = self.searchIconImgView
        self.viewController?.present(engineVC, animated: true)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    // MARK: 🌹 Lazy Init 🌹
    lazy var searchView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemFill
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 30.ckValue()
        return view
    }()
    
    lazy var searchIconImgView: UIImageView = {
        let view = UIImageView(image: Reasource.named(SearchEngineType.google.rawValue))
        view.contentMode = .scaleAspectFit
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var switchEngineBtn: UIButton = {
        let image = Reasource.systemNamed("arrow.up.arrow.down", color: .label)
        let view = UIButton(type: .custom)
        view.setImage(image, for: .normal)
        view.imageView?.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy var clickControl: UIControl = {
        let view = UIControl()
        view.addTarget(self, action: #selector(selectSearchEngine), for: .touchUpInside)
        return view
    }()
    
    lazy var searchButton: UIButton = {
        let image = Reasource.named("search_web").byResize(to: CGSize(width: 25.ckValue(), height: 25.ckValue()))
        
        let view = UIButton(frame: CGRect(x: 0, y: 0, width: 80.ckValue(), height: searchView.layer.cornerRadius * 2))
        view.backgroundColor = .systemBlue
        view.clipsToBounds = true
        view.addBlock(for: .touchUpInside) { [weak self] sender in
            guard let text = self?.searchField.text, text.count > 0 else { return }
            self?.pushHtmlController(text)
        }
        view.setImage(image, for: .normal)
        return view
    }()
    
    lazy var searchField: UITextField = {
        let view = UITextField()
        view.delegate = self
        view.tintColor = appMainColor
        view.returnKeyType = .search
        view.font = UIFont.boldSystemFont(ofSize: 16.ckValue())
        view.textColor = UIColor.label
        view.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20.ckValue(), height: 1))
        view.leftViewMode = .always
        view.textAlignment = PhoneSetManager.isArabicLanguage() ? .right : .left
        view.clearButtonMode = .whileEditing
        return view
    }()
    
}

extension SearchEngineHeadCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let resultStr = textField.text, resultStr.removeSpace().count > 0 {
            self.pushHtmlController(resultStr)
        }
        return true
    }
}
