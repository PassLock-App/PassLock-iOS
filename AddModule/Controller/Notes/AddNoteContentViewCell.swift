//
//  AddNoteContentViewCell.swift
//  PassLock
//
//  Created by melo on 2024/6/5.
//

import KakaFoundation
import KakaUIKit
import AppGroupKit

class AddNoteContentViewCell: UITableViewCell, UITextViewDelegate {
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
        contentView.addSubview(noteTextView)
        contentView.addSubview(placeLabel)
    }
    
    private func preSetupContains() {
        noteTextView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15.ckValue())
            make.top.equalToSuperview()
            make.trailing.equalToSuperview().inset(5.ckValue())
            make.bottom.equalToSuperview()
        }
        
        placeLabel.snp.makeConstraints { make in
            make.leading.equalTo(18.ckValue())
            make.top.equalTo(10.ckValue())
            make.trailing.equalToSuperview().inset(5.ckValue())
            make.height.greaterThanOrEqualTo(0)
        }
        
    }
    
    private func preSetupHandleBuness() {
        self.selectionStyle = .none
    }
    
    // MARK:  GET && SET
    
    var onCallBack: ((String?)->Void)?
    
    var model: PrivateBaseItemModel? {
        didSet {
            let isNotes = (model?.notes?.count ?? 0) > 1
            
            noteTextView.text = model?.notes
            placeLabel.isHidden = isNotes
        }
    }
    
    lazy var noteTextView: UITextView = {
        let view = UITextView()
        view.backgroundColor = .clear
        view.delegate = self
        view.textColor = .label
        view.font = UIFontLight(16.ckValue())
        return view
    }()
    
    lazy var placeLabel: UILabel = {
        
        let message1 = "For example:".localStr()
        let message2 = "1. xx's gift".localStr()
        let message3 = "2. xx's loans".localStr()
        let message4 = "3. xx's indebtedness".localStr()
        
        let message = message1 + "\r" + message2 + "\r" + message3 + "\r" + message4
        
        let view = UILabel()
        view.text = message
        view.font = UIFontLight(12.ckValue())
        view.textColor = UIColor.secondaryLabel
        view.numberOfLines = 0
        return view
    }()
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.placeLabel.isHidden = textView.text.count > 0
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.placeLabel.isHidden = textView.text.count > 0
        
        self.onCallBack?(textView.text)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.placeLabel.isHidden = textView.text.count > 0
        
        self.onCallBack?(textView.text)
    }
    
}
