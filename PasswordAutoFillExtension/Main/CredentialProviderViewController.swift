//
//  CredentialProviderViewController.swift
//  PasswordAutoFillExtension
//
//  Created by Melo on 2023/11/29.
//

import AuthenticationServices
import Toast_Swift
import SnapKit
import AppGroupKit

class CredentialProviderViewController: ASCredentialProviderViewController {
        
    override func prepareCredentialList(for serviceIdentifiers: [ASCredentialServiceIdentifier]) {
        
        self.view.backgroundColor = UIColor.systemBackground
                
        self.dominArray.removeAll()
        let _ = serviceIdentifiers.map { subIdentifier in
            let urlCompon = URLComponents(string: subIdentifier.identifier)
            if let host = urlCompon?.host {
                self.dominArray.append(host)
            }
        }
                        
        self.preSetupSubViews()
        
    }
    
    override func prepareInterfaceForExtensionConfiguration() {
        
        self.view.backgroundColor = UIColor.systemBackground
        
        self.view.addSubview(self.activeView)
    }
    
    override func prepareInterfaceToProvideCredential(for credentialIdentity: ASPasswordCredentialIdentity) {
        debugPrint("### prepareInterfaceToProvideCredential")
    }

    @available(iOSApplicationExtension 17.0, *)
    override func provideCredentialWithoutUserInteraction(for credentialRequest: ASCredentialRequest) {
                
        if credentialRequest.type == .passkeyAssertion {
            if let passkeys = credentialRequest as? ASPasskeyAssertionCredential {
                self.extensionContext.completeAssertionRequest(using: passkeys)
            }
        }else{
            let allSortedArray = self.getAllPasswords()
                    
            let recommentArray = allSortedArray.filter {
                $0.recordId == credentialRequest.credentialIdentity.recordIdentifier
            }
            
            guard let passwordModel = recommentArray.first?.passwordModel, let accountName = passwordModel.accountName, let password = passwordModel.passwords?.first?.password else {
                let error = NSError(domain: ASExtensionErrorDomain, code: ASExtensionError.credentialIdentityNotFound.rawValue)
                self.extensionContext.cancelRequest(withError: error)
                return
            }
            
            self.extensionContext.completeRequest(withSelectedCredential: ASPasswordCredential(user: accountName, password: password), completionHandler: nil)
        }
    }
    
    override func provideCredentialWithoutUserInteraction(for credentialIdentity: ASPasswordCredentialIdentity) {
                
        let allSortedArray = self.getAllPasswords()
                
        let recommentArray = allSortedArray.filter {
            $0.recordId == credentialIdentity.recordIdentifier
        }
        
        guard let passwordModel = recommentArray.first?.passwordModel, let accountName = passwordModel.accountName, let password = passwordModel.passwords?.first?.password else {
            let error = NSError(domain: ASExtensionErrorDomain, code: ASExtensionError.credentialIdentityNotFound.rawValue)
            self.extensionContext.cancelRequest(withError: error)
            return
        }
        
        self.extensionContext.completeRequest(withSelectedCredential: ASPasswordCredential(user: accountName, password: password), completionHandler: nil)
        
    }
    
    public func preSetupSubViews() {
        self.view.addSubview(self.passNaviController.view)
        self.passNaviController.view.frame = self.view.bounds
        self.configUISettings()
    }
    
    func configUISettings() {
        var toastStyle = ToastManager.shared.style
        toastStyle.cornerRadius = 2.ckValue()
        toastStyle.backgroundColor = UIColor.label
        toastStyle.verticalPadding = 12.ckValue()
        toastStyle.horizontalPadding = 18.ckValue()
        toastStyle.titleFont = UIFontLight(15.ckValue())
        toastStyle.messageFont = UIFontLight(15.ckValue())
        toastStyle.titleAlignment = .center
        toastStyle.messageAlignment = .center
        toastStyle.titleColor = UIColor.systemBackground
        toastStyle.messageColor = UIColor.systemBackground
        ToastManager.shared.style = toastStyle
        ToastManager.shared.position = .center
    }
    
    // MARK: 🌹 GET && SET 🌹
    
    lazy var dominArray: [String] = {
        return [String]()
    }()
        
    lazy var sharedUD: UserDefaults
    
    lazy var activeView: ActiveSuccessExtensionView = {
        let view = ActiveSuccessExtensionView(frame: self.view.bounds)
        view.onCancelCallBack = { [weak self] (weakView) in
            self?.complectionExtensionConfig()
        }
        view.onDoneCallBack = { [weak self] (weakView) in
            weakView.removeFromSuperview()
            self?.preSetupSubViews()
        }
        return view
    }()
    
    lazy var passNaviController: UINavigationController = {
        let vc = UINavigationController(rootViewController: passwordVC)
        return vc
    }()
    
    lazy var passwordVC: AllPasswordListController = {
        let vc = AllPasswordListController(self.dominArray)
        vc.delegate = self
        return vc
    }()
    
}

