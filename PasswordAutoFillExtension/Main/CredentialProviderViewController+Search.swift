//
//  CredentialProviderViewController+Search.swift
//  PasswordAutoFillExtension
//
//  Created by Melo on 2024/6/7.
//

import KakaFoundation
import AppGroupKit
import AuthenticationServices

extension CredentialProviderViewController {
    
    
    func getAllPasswords() -> [PrivateBaseItemModel] {
        let userModel = ...
        var allPassArray = [PrivateBaseItemModel]()

        let recordArray: [AppRecordType] = [.defaultBook, .familyBook, .companyBook, .otherBook]
        
        for subType in recordArray {
            let cacheKey = ...
            
            let passArray = ...
            
            allPassArray += passArray
        }
        
        return allPassArray
    }
    
}
