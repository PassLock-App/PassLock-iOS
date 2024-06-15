//
//  AppRecordTypeModel.swift
//  AppGroupKit
//
//  Created by Melo on 2023/11/30.
//

import HandyJSON

public struct AppRecordTypeModel: HandyJSON {
    
    public init() {}
    
    public var recordId: String = ""
    
    public var recordType = AppRecordType.defaultBook
        
    public var isSelected: Bool = false
    
    public var customName: String?
    
    public var customDesc: String?
    
}

extension AppRecordTypeModel {
    public func model1() -> AppRecordTypeModel {
        let recordType = AppRecordType.defaultBook
        
        var model = AppRecordTypeModel()
        model.recordType = recordType
        model.isSelected = true

        return model
    }
    
    public func model2() -> AppRecordTypeModel {
        let recordType = AppRecordType.familyBook

        var model = AppRecordTypeModel()
        model.recordType = recordType
        model.isSelected = false

        return model
    }
    
    public func model3() -> AppRecordTypeModel {
        let recordType = AppRecordType.companyBook
        
        var model = AppRecordTypeModel()
        model.recordType = recordType
        model.isSelected = false

        return model
    }
    
    public func model4() -> AppRecordTypeModel {
        let recordType = AppRecordType.otherBook

        var model = AppRecordTypeModel()
        model.recordType = recordType
        model.isSelected = false

        return model
    }
}
