//
//  AddPasswordTableCell.swift
//  PassLock
//
//  Created by Melo on 2024/6/2.
//

import KakaFoundation
import AppGroupKit

class AddPasswordTableCell: UITableViewCell {
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
        self.selectionStyle = .default
                
        contentView.addSubview(leftImgView)
        contentView.addSubview(passImgView)
        contentView.addSubview(textField)
    }
    
    private func preSetupContains() {
        
        let leftSpace = 18.ckValue()
        
        leftImgView.snp.makeConstraints { make in
            make.leading.equalTo(leftSpace)
            make.centerY.equalToSuperview()
            make.size.equalTo(leftImgView.size)
        }
        
        passImgView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(passImgView.size)
            make.trailing.equalToSuperview().offset(-5.ckValue())
        }
        
        textField.snp.makeConstraints { make in
            make.leading.equalTo(leftImgView.snp.trailing).offset(leftSpace)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(passImgView.snp.leading).offset(-5.ckValue())
            make.height.equalToSuperview()
        }
        
    }
    
    private func preSetupHandleBuness() {
        let attbute: [NSAttributedString.Key: Any] = [.font: UIFontLight(12.ckValue()), .foregroundColor: UIColor.secondaryLabel]
        let placeText = NSAttributedString(string: "Recommend unique password".localStr(), attributes: attbute)
        self.textField.attributedPlaceholder = placeText
        
        self.accessoryType = .disclosureIndicator
    }
    
    // MARK:  GET && SET
    weak var delegate: AddAccountPassDelegate?
    
    var model: PrivateBaseItemModel? {
        didSet {
            guard let model = self.model else {
                return
            }
                        
            textField.text = model.passwordModel?.passwords?.first?.password ?? ""
        }
    }
    
    // MARK:  Lazy Init
    lazy var leftImgView: UIImageView = {
        let view = UIImageView(image: AddItemType.password.leftIconImage())
        view.contentMode = .scaleAspectFit
        view.size = CGSize(width: 22.ckValue(), height: 22.ckValue())
        return view
    }()
    
    private lazy var textField: UITextField = {
        
        let view = UITextField()
        view.tintColor = appMainColor
        view.addTarget(self, action: #selector(nameFieldChanged(_:)), for: .editingChanged)
        view.textContentType = .password
        view.clearButtonMode = .whileEditing
        view.textColor = .label
        view.font = UIFontLight(16.ckValue())
        view.textAlignment = PhoneSetManager.isArabicLanguage() ? .right : .left
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    @objc func nameFieldChanged(_ textField: UITextField) {
        self.delegate?.editPasswordWithCell(cell: self, password: textField.text)
    }
    
    lazy var passImgView: UIImageView = {
        let view = UIImageView(image: Reasource.systemNamed("ellipsis.rectangle", color: UIColor.secondaryLabel))
        view.size = CGSizeMake(20.ckValue(), 20.ckValue())
        view.isUserInteractionEnabled = false
        view.contentMode = .scaleAspectFit
        return view
    }()
}
