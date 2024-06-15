//
//  SafetyTimeTableCell.swift
//  PassLock
//
//  Created by Melo on 2024/6/8.
//

import KakaFoundation

class SafetyTimeTableCell: UITableViewCell, UIContextMenuInteractionDelegate {
    
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
        let interaction = UIContextMenuInteraction(delegate: self)
        self.addInteraction(interaction)
    }
    
    // MARK:  GET && SET
    
    
    // MARK:  Lazy Init
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
            let action1 = UIAction(title: "Option 1", image: nil) { action in
            }
            let action2 = UIAction(title: "Option 2", image: nil) { action in
            }
            let action3 = UIAction(title: "Option 3", image: nil) { action in
            }
            return UIMenu(title: "Choose an Option", children: [action1, action2, action3])
        }
    }
    
}
