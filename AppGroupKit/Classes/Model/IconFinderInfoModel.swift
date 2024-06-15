//
//  IconFinderInfoModel.swift
//  PassLock
//
//  Created by Melo Dreek on 2023/8/6.
//

import HandyJSON

public struct IconFinderInfoModel: HandyJSON {
    
    public init() {
        
    }
    
    public init(icon_id: Int, is_premium: Bool, is_icon_glyph: Bool, tags: [String], raster_sizes: [IconFinderSizeModel]) {
        self.icon_id = icon_id
        self.is_premium = is_premium
        self.is_icon_glyph = is_icon_glyph
        self.tags = tags
        self.raster_sizes = raster_sizes
    }
    
    public var icon_id: Int = 0
    
    public var is_premium: Bool = false
    
    public var is_icon_glyph: Bool = false
    
    public var tags: [String] = []
    
    public var raster_sizes: [IconFinderSizeModel] = []
    
    public func middleSizeModel() -> IconFinderSizeModel? {
        
        if self.raster_sizes.count < 3 {
            return self.raster_sizes.last
        }
        
        let sortedArray = self.raster_sizes.sorted(by: { model1, model2 in
            return model1.size_width > model2.size_width
        })
       
        let index = sortedArray.count / 2
        
        let middleModel = sortedArray[index]
        
        return middleModel
   }
}

public struct IconFinderSizeModel: HandyJSON {
    
    public init() {
        
    }
    
    public init(size: CGFloat, size_height: CGFloat, size_width: CGFloat, formats: [IconFinderDownload]) {
        self.size = size
        self.size_height = size_height
        self.size_width = size_width
        self.formats = formats
    }
    
    public var size: CGFloat = 0
    
    public var size_height: CGFloat = 0
    
    public var size_width: CGFloat = 0
    
    public var formats: [IconFinderDownload] = []
    
}

public struct IconFinderDownload: HandyJSON {
    
    public init() {
        
    }
    
    public init(format: String, preview_url: String, download_url: String) {
        self.format = format
        self.preview_url = preview_url
        self.download_url = download_url
    }
    
    public var format: String = ""
    
    public var preview_url: String = ""
    
    public var download_url: String = ""
}
