//
//  ShareHealthScoreView.swift
//  PassLock
//
//  Created by Melo on 2024/1/9.
//

import KakaFoundation
import KakaUIKit
import AppGroupKit

class ShareHealthScoreView: UIView {
    
    init(frame: CGRect, score: Double, status: PassHealthStatus) {
        self.score = score
        self.status = status
        super.init(frame: frame)
        
        self.preSetupSubViews()
        self.preSetupContains()
        self.preSetupHandleBuness()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func preSetupSubViews() {
        self.addSubview(contentView)
        self.addSubview(shareButton)
        self.addSubview(cancelButton)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(persentView)
        contentView.addSubview(scoreLabel)
        contentView.addSubview(statusLabel)
        
        contentView.addSubview(healthLabel)
        contentView.addSubview(downloadView)
        contentView.addSubview(appstoreView)
        contentView.addSubview(appNameLabel)
        downloadView.addSubview(passlockLabel)
    }
    
    private func preSetupContains() {
        contentView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.size.equalTo(contentView.size)
        }
        
        shareButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(contentView.snp.bottom).offset(-30.ckValue())
            make.size.equalTo(shareButton.size)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(contentView.snp.bottom).offset(20.ckValue())
            make.size.equalTo(40.ckValue())
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(10.ckValue())
            make.size.greaterThanOrEqualTo(0)
        }
        
        persentView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(10.ckValue())
            make.size.equalTo(persentView.size)
        }
        
        scoreLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(persentView)
            make.size.greaterThanOrEqualTo(0)
        }
        
        statusLabel.snp.makeConstraints { make in
            make.centerX.equalTo(persentView)
            make.top.equalTo(scoreLabel.snp.bottom).offset(5.ckValue())
            make.size.greaterThanOrEqualTo(0)
        }
        
        appNameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(30.ckValue())
            make.size.greaterThanOrEqualTo(0)
        }
        
        downloadView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.equalTo(persentView).offset(-10.ckValue())
            make.bottom.equalTo(appNameLabel.snp.top).offset(-15.ckValue())
            make.height.equalTo(44.ckValue())
        }
        
        healthLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(shareButton.snp.top).inset(-30.ckValue())
            make.size.greaterThanOrEqualTo(0)
        }
        
        appstoreView.snp.makeConstraints { make in
            make.trailing.equalTo(downloadView).offset(-10.ckValue())
            make.centerY.equalTo(downloadView)
            make.height.equalTo(downloadView).multipliedBy(0.72)
            make.width.equalTo(appstoreView.snp.height)
        }
        
        passlockLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15.ckValue())
            make.centerY.equalToSuperview()
            make.size.greaterThanOrEqualTo(0)
        }
        
    }
    
    private func preSetupHandleBuness() {
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        persentView.startSpeedAnimation(status)
        
    }
    
    @objc func shareButtonClick() {
        downloadView.isHidden = false
        appNameLabel.isHidden = false
        healthLabel.isHidden = true
        appstoreView.isHidden = false
        
        guard let image = self.contentView.snapshotImageCorner(contentView.layer.cornerRadius) else {
            self.contentView.kaka_playShakeAnim()
            return
        }
        
        
        self.removeFromSuperview()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kShareAccountHealthKey), object: image, userInfo: nil)
    }
    
    @objc func cancelButtonClick() {
        self.removeFromSuperview()
    }
    
    // MARK: 🌹 GET && SET 🌹
    var score: Double!
    var status: PassHealthStatus!
    
    
    // MARK: 🌹 Lazy init 🌹
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.text = self.status.emojiTitle()
        view.font = UIFont(name: "AppleColorEmoji", size: 60)
        view.textAlignment = .center
        view.textColor = UIColor.rgb(20, 25, 33)
        return view
    }()
    
    lazy var contentView: UIView = {
        let width = self.viewController?.view.width ?? 320.ckValue()
        let height = self.viewController?.view.height ?? 460.ckValue()
        
        let view = UIView(frame: CGRectMake(0, 0, width, height))
        view.backgroundColor = appMainColor
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 12.ckValue()
        return view
    }()
    
    lazy var persentView: HealthPersentView = {
        let height = kaka_IsiPad() ? 400.0 : 200.ckValue()
        let view = HealthPersentView(frame: CGRect(x: 0, y: 0, width: height, height: height))
        return view
    }()
    
    lazy var statusLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.text = self.status.statusTitle()
        view.textColor = UIColor(cgColor: self.status.gradColors().first!)
        view.font = UIFontBold(15.ckValue())
        return view
    }()
    
    lazy var scoreLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.attributedText = self.scoreAttbuteStr(title: String(format: "%.f", score), color: statusLabel.textColor, font: UIFontBold(48.ckValue()))
        return view
    }()
    
    lazy var passlockLabel: UILabel = {
        let view = UILabel()
        view.text = "PassLock".localStr()
        view.font = UIFontBold(14.ckValue())
        view.textColor = UIColor.rgb(33, 33, 45)
        return view
    }()
    
    lazy var downloadView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10.ckValue()
        view.backgroundColor = UIColor.clear
        view.layer.borderWidth = 2.ckValue()
        view.layer.borderColor = UIColor.systemBlue.withAlphaComponent(0.8).cgColor
        return view
    }()
    
    lazy var appstoreView: UIImageView = {
        let image = Reasource.named("appstore")
        let view = UIImageView()
        view.image = image
        view.isHidden = true
        return view
    }()
    
    lazy var healthLabel: UILabel = {
        let view = UILabel()
        view.text = "My Password Health Score".localStr()
        view.font = UIFontLight(13.ckValue())
        view.textAlignment = .center
        view.textColor = UIColor.white
        return view
    }()
    
    lazy var appNameLabel: UILabel = {
        let view = UILabel()
        view.text = "Test your password health".localStr()
        view.font = UIFontLight(13.ckValue())
        view.textAlignment = .center
        view.textColor = UIColor.gray
        view.isHidden = true
        return view
    }()
    
    lazy var shareButton: UIButton = {
        let view = UIButton(frame: CGRectMake(0, 0, 250.ckValue(), 44.ckValue()))
        view.backgroundColor = .white
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 22.ckValue()
        view.setTitle("Share with friends".localStr(), for: .normal)
        view.titleLabel?.font = UIFontBold(15.ckValue())
        view.setTitleColor(appMainColor, for: .normal)
        view.addTarget(self, action: #selector(shareButtonClick), for: .touchUpInside)
        return view
    }()
    
    lazy var cancelButton: UIButton = {
        let view = UIButton(type: .custom)
        view.setImage(Reasource.systemNamed("xmark.circle", color: UIColor.white), for: .normal)
        view.addTarget(self, action: #selector(cancelButtonClick), for: .touchUpInside)
        return view
    }()
    
    func scoreAttbuteStr(title: String, color: UIColor, font: UIFont) -> NSAttributedString {
        let sizeValue = 128.0 / 61
        let attach1 = NSTextAttachment()
        attach1.image = Reasource.named("maizi_left").withTintColor(color)
        attach1.bounds = CGRect(x: 0, y: -3.ckValue(), width: 12.ckValue(), height: 12.ckValue() * sizeValue)
        
        let attach2 = NSTextAttachment()
        attach2.image = Reasource.named("maizi_right").withTintColor(color)
        attach2.bounds = attach1.bounds
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attbutes: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: color, .paragraphStyle: paragraphStyle]
        
        let attributedText = NSMutableAttributedString()
        attributedText.append(NSAttributedString(attachment: attach1))
        attributedText.append(NSAttributedString(string: " " + title + " ", attributes: attbutes))
        attributedText.append(NSAttributedString(attachment: attach2))
        
        return attributedText
    }
}

