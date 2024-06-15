//
//  AppRecordType+PassExtension.swift
//  PasswordAutoFillExtension
//
//  Created by 张文 on 2023/12/12.
//

import AppGroupKit

extension AppRecordType {
    public func nameStr() -> String {
        switch self {
        case .defaultBook:
            return "Personal".localStr()
        case .familyBook:
            return "Family".localStr()
        case .companyBook:
            return "Business".localStr()
        case .otherBook:
            return "Others".localStr()
        }
    }
}
