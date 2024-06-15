//
//  WebsiteOpsViewCell.swift
//  PassLock
//
//  Created by Melo on 2023/9/12.
//

import KakaFoundation
import KakaUIKit
import AppGroupKit
import SafariServices

class WebsiteOpsViewCell: UITableViewCell, SFSafariViewControllerDelegate {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.preSetupSubViews()
        self.preSetupContains()
        self.preSetupHandleBuness()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func preSetupSubViews() {
        contentView.addSubview(iconView)
        contentView.addSubview(nameLabel)
    }
    
    private func preSetupContains() {
        
        iconView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.size.equalTo(300.ckValue())
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(iconView.snp.bottom)
            make.leading.equalToSuperview().offset(30.ckValue())
            make.height.greaterThanOrEqualTo(0)
            make.bottom.equalToSuperview().inset(30.ckValue())
        }
        
    }
    
    private func preSetupHandleBuness() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
    }
    
    // MARK: 🌹 GET && SET 🌹
    @objc func contactButtonClick() {
        if kaka_IsMacOS() {
            guard let vUrl = URL(string: kProductDocumentUrl) else { return }

            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            let safariVC = SFSafariViewController(url: vUrl, configuration: config)
            safariVC.delegate = self
            self.viewController?.present(safariVC, animated: true)
        } else {
            let webVC = WKWebViewController(urlStr: kProductDocumentUrl)
            self.viewController?.navigationController?.pushViewController(webVC, animated: true)
        }
    }
    
    // MARK: 🌹 Lazy Init 🌹
    
    lazy var iconView: UIImageView = {
        let svgURL = Reasource.svgFileUrl("search_engine")
        let view = UIImageView()
        view.sd_setImage(with: URL(fileURLWithPath: svgURL), placeholderImage: nil)
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let view = UILabel()
        view.text = "Get icons through the search engine and the URLs needed to auto-fill passwords.".localStr()
        view.numberOfLines = 0
        view.font = UIFontLight(15.ckValue())
        view.textAlignment = .center
        view.textColor = UIColor.label
        return view
    }()
    
}
