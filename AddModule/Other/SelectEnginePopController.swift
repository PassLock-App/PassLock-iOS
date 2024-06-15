//
//  SelectEnginePopController.swift
//  PassLock
//
//  Created by Melo on 2023/9/9.
//

import KakaFoundation
import KakaUIKit
import AppGroupKit

class SelectEnginePopController: SuperViewController, UITableViewDataSource, UITableViewDelegate {
    
    override func preSetupSubViews() {
        super.preSetupSubViews()
        contentView.addSubview(tableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = contentView.bounds
    }
    
    override func preSetupHandleBuness() {
        super.preSetupHandleBuness()
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectEngineViewCell", for: indexPath) as! SelectEngineViewCell
        let passType = dataArray[indexPath.row]
        cell.update(passType)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let passType = dataArray[indexPath.row]
        AppLocalManager.shared.lastSearchEngine = passType
        self.dismiss(animated: true)
        self.onSelectCallBack?(passType)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    // MARK: 🌹 GET && SET 🌹
    lazy var dataArray: [SearchEngineType] = {
        return [.google, .bing, .yahooJapan, .naver, .yandex]
    }()
    
    var onSelectCallBack: ((SearchEngineType)->Void)?
    
    let cellHeight = 60.ckValue()
    
    
    // MARK: 🌹 Lazy Init 🌹
    lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.dataSource = self
        view.delegate = self
        view.rowHeight = cellHeight
        view.contentInsetAdjustmentBehavior = .automatic
        view.register(SelectEngineViewCell.self, forCellReuseIdentifier: "SelectEngineViewCell")
        return view
    }()
    
}

class SelectEngineViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .default
        self.accessoryType = .disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(_ engineType: SearchEngineType) {
        var cellConfig = UIListContentConfiguration.accompaniedSidebarCell()
        cellConfig.image = Reasource.named(engineType.iconName())
        cellConfig.text = engineType.nameStr()
        cellConfig.imageProperties.maximumSize = CGSizeMake(30.ckValue(), 30.ckValue())
        
        cellConfig.textProperties.color = UIColor.label
        cellConfig.textProperties.numberOfLines = 1
        cellConfig.textProperties.font = UIFontLight(16.ckValue())
        
        cellConfig.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 15)
        cellConfig.imageToTextPadding = 15
        
        self.contentConfiguration = cellConfig
    }

}
