//
//  TransparencyViewController.swift
//  SV
//
//  Created by Melo Dreek on 2023/2/9.
//

import KakaFoundation
import KakaUIKit
import StoreKit
import YYText
import AppGroupKit
import SafariServices
import ManagedSettings

class TransparencyViewController: SuperViewController {
    
    override func preSetupSubViews() {
        super.preSetupSubViews()
        
        self.title = KakaTabbarItem.developer.formatStr()
        contentView.addSubview(tableView)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = contentView.bounds
        
        headView.size = CGSize(width: self.view.width, height: TransparencyHeadView.allheight(self.view.width))
        footView.size = CGSize(width: self.view.width, height: GuideRateReviewView.allheight(self.view.width))
    }
    
    override func preSetupHandleBuness() {
        super.preSetupHandleBuness()
        
        NotificationCenter.default.addObserver(self, selector: #selector(appModeStyleChanged(_:)), name: NSNotification.Name(rawValue: kAppThemeColorChangedKey), object: nil)
    }
    
    @objc func appModeStyleChanged(_ noti: Notification) {
        self.tableView.reloadData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.tableView.layoutIfNeeded()
    }

    // MARK: 🌹 GET && SET 🌹
    
        
    lazy var dataArray: [TransparencyCellModel] = {
        let model1 = TransparencyCellModel(group: .transparency, headTitle: "Product transparency".localStr(), itemArray: [.openSource, .iCloudBackup, .producuStory], footTitle: nil)
        let model2 = TransparencyCellModel(group: .others, headTitle: "Technical Support".localStr(), itemArray: [.faqs, .contactMail], footTitle: nil)
        return [model1, model2]
    }()
        
    // MARK: 🌹 LAZY 🌹
    
    lazy var tableView: UITableView = {
        let view = UITableView(frame: self.view.bounds, style: .insetGrouped)
        view.dataSource = self
        view.delegate = self
        view.rowHeight = 55.ckValue()
        view.contentInsetAdjustmentBehavior = .automatic
        view.tableHeaderView = self.headView
        view.tableFooterView = self.footView
        view.register(TransparencyTableCell.self, forCellReuseIdentifier: "TransparencyTableCell")
        return view
    }()
    
    lazy var headView: TransparencyHeadView = {
        let view = TransparencyHeadView(frame: CGRectMake(0, 0, self.view.width, TransparencyHeadView.allheight(self.view.width)))
        return view
    }()
    
    lazy var footView: GuideRateReviewView = {
        let view = GuideRateReviewView(frame: CGRectMake(0, 0, self.view.width, GuideRateReviewView.allheight(self.view.width)))
        view.delegate = self
        return view
    }()
    
}

