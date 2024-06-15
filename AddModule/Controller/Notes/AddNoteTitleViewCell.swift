//
//  AddNoteTitleViewCell.swift
//  PassLock
//
//  Created by melo on 2024/6/5.
//

import KakaFoundation
import KakaUIKit
import AppGroupKit

class AddNoteTitleViewCell: UITableViewCell {
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
        let attbute: [NSAttributedString.Key: Any] = [.font: UIFontLight(12.ckValue()), .foregroundColor: UIColor.secondaryLabel]
        let placeText = NSAttributedString(string: "e.g. xxx's Christmas gift".localStr(), attributes: attbute)
        self.textField.attributedPlaceholder = placeText
        
        self.selectionStyle = .default
        self.accessoryType = .disclosureIndicator
    }
    
    var onCallBack: ((String?)->Void)?
    
    // MARK:  GET && SET
    var model: PrivateBaseItemModel? {
        didSet {
            textField.text = model?.notes
        }
    }
    
    
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
        self.onCallBack?(textField.text)
    }
    
}

