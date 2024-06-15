//
//  CredentialProviderViewController+Delegate.swift
//  PasswordAutoFillExtension
//
//  Created by Melo on 2024/6/6.
//

import AppGroupKit
import AuthenticationServices

extension CredentialProviderViewController: AllPasswordListControllerDelegate {
    func passwordControllerDidDismiss(controller: AllPasswordListController) {
        self.dismissAction()
    }
    
    func passwordControllerDidSelect(controller: AllPasswordListController, account: String, passModel: PasswordListModel) {
        if ... {
            self.complectionExtensionConfig()
        }else{
            self.passwordSelected(account: account, password: passModel.password)
        }
    }
    
}

extension CredentialProviderViewController {
    @objc public func dismissAction() {
        let error = NSError(domain: ASExtensionErrorDomain, code: ASExtensionError.userCanceled.rawValue)
        self.extensionContext.cancelRequest(withError: error)
    }
    
    @objc func complectionExtensionConfig() {
        self.extensionContext.completeExtensionConfigurationRequest()
    }

    public func passwordSelected(account: String, password: String) {
        let passwordCredential = ASPasswordCredential(user: account, password: password)
        self.extensionContext.completeRequest(withSelectedCredential: passwordCredential, completionHandler: nil)
    }
    
}
