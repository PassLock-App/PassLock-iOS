//
//  PassCreaterViewController.swift
//  SV
//
//  Created by Melo Dreek on 2023/2/8.
//

import KakaFoundation
import KakaUIKit
import AppGroupKit


class PassCreaterViewController: SuperViewController {
    
    override func preSetupSubViews() {
        super.preSetupSubViews()
        
        contentView.addSubview(tableView)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = contentView.bounds
        footView.size = CGSize(width: self.view.width, height: GuideRateReviewView.allheight(self.view.width))
    }
    
    override func preSetupHandleBuness() {
        super.preSetupHandleBuness()
        self.resetSubViews()
        
        self.title = kaka_IsiPhone() ? KakaTabbarItem.creater.formatStr() : "Strong Password Generator".localStr()
        self.navigationItem.rightBarButtonItem = self.recordBarItem

    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.tableView.layoutIfNeeded()
    }
    
    func resetSubViews() {
        if self.isPresent() {
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.65) { [weak self] () in
            guard let wSelf = self else { return }
            guard let createCell = wSelf.tableView.cellForRow(at: IndexPath(row: 0, section: PassCreaterSource.createPass.rawValue)) as? GeneratePassTableCell else {
                return
            }
            
            createCell.copypassButton.kaka_playShakeAnim()
        }
    }
    
    @objc func recordsBarClick() {
        let recordVC = CopiedRecordsViewController()
        self.navigationController?.pushViewController(recordVC, animated: true)
    }
    
    // MARK: 🌹 GET && SET 🌹
    
    var onCopyCallBack: ((PasswordListModel)->Void)?
    
    
    lazy var dataArray: [PassCreaterSource] = {
        return [.welcomeCard, .createPass, .whatStrongPass, .whyStrongPass]
    }()
    
    // MARK: 🌹 Lazy Init 🌹
    
    lazy var tableView: UITableView = {
        let view = UITableView(frame: self.view.bounds, style: .insetGrouped)
        view.dataSource = self
        view.delegate = self
        view.rowHeight = UITableView.automaticDimension
        view.contentInsetAdjustmentBehavior = .automatic
        view.tableFooterView = self.footView
        view.register(WelcomeCreatePassCell.self, forCellReuseIdentifier: "WelcomeCreatePassCell")
        view.register(GeneratePassTableCell.self, forCellReuseIdentifier: "GeneratePassTableCell")
        view.register(StrongPasswordViewCell.self, forCellReuseIdentifier: "StrongPasswordViewCell")
        return view
    }()
    
    lazy var footView: GuideRateReviewView = {
        let view = GuideRateReviewView(frame: CGRectMake(0, 0, self.view.width, GuideRateReviewView.allheight(self.view.width)))
        view.delegate = self
        return view
    }()
    
    lazy var recordBarItem: UIBarButtonItem = {
        if kaka_IsMacOS() {
            let item = UIBarButtonItem(title: "Copied records".localStr(), style: .done, target: self, action: #selector(recordsBarClick))
            return item
        }else{
            if #available(iOS 15.0, *) {
                let item = UIBarButtonItem(image: UIImage(systemName: "clock.badge.checkmark"), style: .done, target: self, action: #selector(recordsBarClick))
                return item
            }else{
                let item = UIBarButtonItem(image: UIImage(systemName: "clock"), style: .done, target: self, action: #selector(recordsBarClick))
                return item
            }
        }
    }()
    
    lazy var strongPass1: StrongPassword = {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3.ckValue()
        paragraphStyle.alignment = .center
        
        let titleAttbuteStr = NSAttributedString(string: "Why should passwords be unique?".localStr(), attributes: [NSAttributedString.Key.font: UIFontBold(18.ckValue()), NSAttributedString.Key.foregroundColor: UIColor.label, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        
        let messageAttbuteStr = NSAttributedString(string: "If your email account and bank account use the same password for login, attackers only need to steal one password to access both accounts, effectively doubling your risk. If you use the same password for 20 different accounts, then the attacker's job becomes very, very easy. You know, on the infamous Dark Web, there are already tens of billions of data being traded!".localStr(), attributes: [NSAttributedString.Key.font: UIFontLight(16.ckValue()), NSAttributedString.Key.foregroundColor: UIColor.label.withAlphaComponent(0.75), NSAttributedString.Key.paragraphStyle: paragraphStyle])
        
        let attbuteStr = StrongPassword(iconName: "strong_pass_1",title: titleAttbuteStr, message: messageAttbuteStr)
        return attbuteStr
    }()
    
    lazy var strongPass2: StrongPassword = {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3.ckValue()
        paragraphStyle.alignment = .center
        
        let titleAttbuteStr = NSAttributedString(string: "What makes a strong password?".localStr(), attributes: [NSAttributedString.Key.font: UIFontBold(18.ckValue()), NSAttributedString.Key.foregroundColor: UIColor.label, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        
        let messageAttbuteStr = NSAttributedString(string: "We tend not to be very good at coming up with passwords that are complex and long enough, let alone both. So we created PassLock Strong Password Generator to create secure strong passwords for you. 81% of data breaches are caused by duplicate or weak passwords, so random and unique passwords are the best defense against online threats.".localStr(), attributes: [NSAttributedString.Key.font: UIFontLight(16.ckValue()), NSAttributedString.Key.foregroundColor: UIColor.label.withAlphaComponent(0.75), NSAttributedString.Key.paragraphStyle: paragraphStyle])
        
        let attbuteStr = StrongPassword(iconName: "strong_pass_2",title: titleAttbuteStr, message: messageAttbuteStr)
        return attbuteStr
    }()
}

