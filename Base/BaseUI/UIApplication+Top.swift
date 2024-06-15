//
//  UIApplication+Top.swift
//  PassLock
//
//  Created by Melo on 2023/12/2.
//

import KakaUIKit
import KakaFoundation

extension UIViewController {
    public func isPresent() -> Bool {
        let isPresent = (self.navigationController?.viewControllers.count ?? 1) == 1
        return isPresent
    }
  
    public func showTwoAlert(title: String = "Tip".localStr(), message: String, confirm: String = "Confirm".localStr(), cancle: String = "Cancel".localStr(), complete: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action1 = UIAlertAction(title: confirm, style: .destructive) { (sender) in
            complete?()
        }
        let action2 = UIAlertAction(title: cancle, style: .cancel) { (sender) in
            
        }
        
        alertController.addAction(action1)
        alertController.addAction(action2)
        self.present(alertController, animated: true, completion: nil)
    }
    
    public func showOneAlert(title: String, message: String, confirm: String = "Confirm".localStr(), complete: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: confirm, style: .default) { (sender) in
            complete?()
        }
        
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
  
}
