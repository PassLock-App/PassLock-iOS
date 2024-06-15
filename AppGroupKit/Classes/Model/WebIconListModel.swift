//
//  WebIconListModel.swift
//  AppGroupKit
//
//  Created by Melo on 2023/12/1.
//

import HandyJSON

public struct WebIconListModel: HandyJSON {
    
    public init() {
        
    }
    
    public init(domain: String, icons: [IconsInfo]) {
        self.domain = domain
        self.icons = icons
    }
    
    public var domain: String = ""
    
    public var icons: [IconsInfo] = []
    
}

public struct IconsInfo: HandyJSON {
    
    public init() {
        
    }
    
    public init(sizes: String? = nil, src: String, type: String? = nil) {
        self.sizes = sizes
        self.src = src
        self.type = type
    }
    
    public var sizes: String?
    
    public var src: String = ""
    
    public var type: String?
    
    public func isSVG() -> Bool {
        guard let vUrl = URL(string: self.src) else { return false }
        
        return vUrl.pathExtension.lowercased() == "svg" ? true : false
    }
}
