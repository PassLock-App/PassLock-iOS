//
//  SocialEventModel.swift
//  PassLock
//
//  Created by Melo Dreek on 2023/6/22.
//

import HandyJSON
import KakaFoundation

enum SocialEventType: Int {
    case news1 = 1
    case news2 = 2
    case news3 = 3
    
    func headSvgURL() -> URL {
        switch self {
        case .news1:
            return URL(fileURLWithPath: Reasource.svgFileUrl("new_head_1"))
        case .news2:
            return URL(fileURLWithPath: Reasource.svgFileUrl("new_head_2"))
        case .news3:
            return URL(fileURLWithPath: Reasource.svgFileUrl("new_head_3"))
        }
    }
}

struct SocialEventModel: HandyJSON {
    
    var newsType = SocialEventType.news1
    
    var newsTitle: String = ""
    
    var coverImage: UIImage?
    
    var from: String = ""
    
}
