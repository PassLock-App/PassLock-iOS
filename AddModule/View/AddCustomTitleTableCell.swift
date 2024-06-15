//
//  AddCustomTitleTableCell.swift
//  PassLock
//
//  Created by Melo Dreek on 2023/5/6.
//

import KakaUIKit
import KakaFoundation
import AppGroupKit

class AddCustomTitleTableCell: UITableViewCell {
    
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
        contentView.addSubview(leftImgView)
        contentView.addSubview(textField)
    }
    
    private func preSetupContains() {
        
        let leftSpace = 18.ckValue()
        
        leftImgView.snp.makeConstraints { make in
            make.leading.equalTo(leftSpace)
            make.centerY.equalToSuperview()
            make.size.equalTo(leftImgView.size)
        }
        
        textField.snp.makeConstraints { make in
            make.leading.equalTo(leftImgView.snp.trailing).offset(leftSpace)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalToSuperview()
        }
        
    }
    
    private func preSetupHandleBuness() {
        self.selectionStyle = .default
        self.accessoryType = .disclosureIndicator
    }
    
    // MARK: 🌹 GET && SET 🌹
    
    weak var delegate: AddAccountPassDelegate?
    
    var model: PrivateBaseItemModel? {
        didSet {
            textField.text = model?.customTitle ?? ""
        }
    }
    
    func updatePlaceholder(_ placeText: String) {
        let attbute: [NSAttributedString.Key: Any] = [.font: UIFontLight(12.ckValue()), .foregroundColor: UIColor.secondaryLabel]
        let placeText = NSAttributedString(string: placeText, attributes: attbute)
        self.textField.attributedPlaceholder = placeText
    }
            
    // MARK: 🌹 Lazy Init 🌹
    lazy var leftImgView: UIImageView = {
        let view = UIImageView(image: AddItemType.customTitle.leftIconImage())
        view.contentMode = .scaleAspectFit
        view.size = CGSize(width: 22.ckValue(), height: 22.ckValue())
        return view
    }()
    
    private lazy var textField: UITextField = {
        
        let view = UITextField()
        view.tintColor = appMainColor
        view.addTarget(self, action: #selector(cusNameFieldChanged), for: .editingChanged)
        view.textContentType = .name
        view.clearButtonMode = .whileEditing
        view.textColor = .label
        view.font = UIFontLight(16.ckValue())
        view.textAlignment = PhoneSetManager.isArabicLanguage() ? .right : .left
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    @objc func cusNameFieldChanged(_ textField: UITextField) {
        self.delegate?.editCustomTitleWithCell(cell: self, customTitle: textField.text)
    }
    
}
