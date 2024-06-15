//
//  SwitchItemTypePopController.swift
//  SV
//
//  Created by Melo Dreek on 2023/2/11.
//

import KakaUIKit
import KakaFoundation
import AppGroupKit

class SwitchItemTypePopController: SuperViewController, UITableViewDataSource, UITableViewDelegate {
    
    deinit {
        debugPrint("### SwitchItemTypePopController ###")
    }
    
    init(_ storageItems: [StorageItemType]) {
        self.dataArray = storageItems
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    // MARK:  GET && SET
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddPassTypeTablecell", for: indexPath) as! AddPassTypeTablecell
        let passType = dataArray[indexPath.row]
        cell.passType = passType
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let passType = dataArray[indexPath.row]
        AppLocalManager.shared.lastItemType = passType
        self.dismiss(animated: true)
        self.onSelectCallBack?(passType)
    }
    
    // MARK: 🌹 GET && SET 🌹
    var onSelectCallBack: ((StorageItemType)->Void)?
    
    private var dataArray: [StorageItemType]!
    
    lazy var tableView: UITableView = {
        let view = UITableView(frame: self.view.bounds, style: .plain)
        view.dataSource = self
        view.delegate = self
        view.rowHeight = UITableView.automaticDimension
        view.contentInsetAdjustmentBehavior = .automatic
        view.contentInset = UIEdgeInsets(top: AddPassTypeTablecell.insetsTop, left: 0, bottom: 0, right: 0)
        view.register(AddPassTypeTablecell.self, forCellReuseIdentifier: "AddPassTypeTablecell")
        return view
    }()


}

class AddPassTypeTablecell: UITableViewCell {
    
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
        
    }
    
    private func preSetupContains() {
        
    }
    
    private func preSetupHandleBuness() {
        self.accessoryType = .disclosureIndicator
        self.selectionStyle = .default
    }
    
    static var titleFont: UIFont {
        get {
            switch kaka_osType() {
            case .iOS: return UIFontLight(17.ckValue())
            case .iPadOS: return UIFontLight(17.ckValue())
            case .macOS: return UIFontLight(17.ckValue())
            }
        }
    }
    
    static var secondFont: UIFont {
        get {
            switch kaka_osType() {
            case .iOS: return UIFontLight(12.ckValue())
            case .iPadOS: return UIFontLight(12.ckValue())
            case .macOS: return UIFontLight(12.ckValue())
            }
        }
    }
    
    static var insetsTop: CGFloat {
        get {
            switch kaka_osType() {
            case .iOS: return 5.ckValue()
            case .iPadOS: return 5.ckValue()
            case .macOS: return 15.ckValue()
            }
        }
    }
    
    
    // MARK: 🌹 GET && SET 🌹
    var passType: StorageItemType? {
        didSet {
            guard let passType = passType else { return }
            
            var cellConfig = UIListContentConfiguration.cell()
            cellConfig.image = passType.systemIconImage()
            cellConfig.text = passType.nameStr()
            cellConfig.secondaryText = passType.descStr()
            cellConfig.imageProperties.maximumSize = CGSizeMake(25.ckValue(), 25.ckValue())
            cellConfig.textProperties.color = UIColor.label
            cellConfig.imageProperties.tintColor = .label
            cellConfig.textProperties.font = Self.titleFont
            cellConfig.secondaryTextProperties.font = Self.secondFont
            cellConfig.imageToTextPadding = 15.ckValue()

            cellConfig.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 15)
            
            self.contentConfiguration = cellConfig
        }
    }
    
    class func cellContentSize(maxWidth: CGFloat, storage: StorageItemType) -> CGSize {
        let allWidth = maxWidth
        var allheight = 0.0
        
        let descWidth = allWidth - 25.ckValue() - 30.ckValue() - 40.ckValue()
        let descHeight = storage.descStr().ocString.height(for: Self.secondFont, width: descWidth)
        let titleHeight = Self.titleFont.lineHeight
        
        allheight = 15.ckValue() + titleHeight + 2.ckValue() + descHeight + 15.ckValue()
        
        return CGSize(width: allWidth, height: allheight + AddPassTypeTablecell.insetsTop * 2)
    }
    
}
