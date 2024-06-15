//
//  CloudKitConsoleViewController.swift
//  PassLock
//
//  Created by MELO on 2024/5/29.
//

import KakaFoundation
import KakaPhotoBrowser
import StoreKit

class CloudKitConsoleViewController: SuperViewController {
    
    deinit {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: windowScene)
        }
    }
    
    override func preSetupSubViews() {
        super.preSetupSubViews()
        contentView.addSubview(tableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = contentView.bounds
        headView.size = CGSize(width: self.view.width, height: CloudKitConsoleHeadView.allheight(self.view.width))
    }
    
    override func preSetupHandleBuness() {
        super.preSetupHandleBuness()
        self.title = TransparencyItemType.iCloudBackup.titleStr()
    }
    
    // MARK:  GET && SET
    lazy var dataArray: [CloudKitConsoleItemType] = {
        let model1 = CloudKitConsoleItemType.console1
        let model2 = CloudKitConsoleItemType.console2
        let model3 = CloudKitConsoleItemType.console3
        let model4 = CloudKitConsoleItemType.console4
        let model5 = CloudKitConsoleItemType.console5
        return [model1, model2, model3, model4, model5]
    }()

    lazy var tableView: UITableView = {
        let view = UITableView(frame: self.view.bounds, style: .insetGrouped)
        view.dataSource = self
        view.delegate = self
        view.rowHeight = UITableView.automaticDimension
        view.contentInsetAdjustmentBehavior = .automatic
        view.tableHeaderView = self.headView
        view.register(CloudKitConsoleViewCell.self, forCellReuseIdentifier: "CloudKitConsoleViewCell")
        return view
    }()
    
    lazy var headView: CloudKitConsoleHeadView = {
        let view = CloudKitConsoleHeadView(frame: CGRectMake(0, 0, self.view.width, CloudKitConsoleHeadView.allheight(self.view.width)))
        return view
    }()
}

extension CloudKitConsoleViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let itemType = dataArray[indexPath.section]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CloudKitConsoleViewCell", for: indexPath) as! CloudKitConsoleViewCell
        cell.model = itemType
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let itemType = dataArray[indexPath.section]
        
        if itemType == .consoleHead { return }
        
        var tempArray = [KakaPhotoItem]()
        for index in 0..<dataArray.count {
            let subItem = dataArray[index]
            let sourceView = UIImageView(frame: CGRectMake(0, 0, 1, 1))
            sourceView.center = self.view.center
            sourceView.isHidden = true
            self.view.addSubview(sourceView)
            let item = KakaPhotoItem(sourceView: sourceView, image: subItem.cellImage())
            tempArray.append(item)
        }
                                
        let browser = KakaPhotoBrowser(photoItems: tempArray, selectedIndex: UInt(indexPath.section))
        browser.backgroundStyle = .blurPhoto
        browser.show(from: self)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataArray[section].headStr()
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return dataArray[section].footStr()
    }
        
}


