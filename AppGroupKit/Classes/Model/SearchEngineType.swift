//
//  SearchEngineType.swift
//  AppGroupKit
//
//  Created by Melo on 2023/12/1.
//

import KakaFoundation
import HandyJSON

public enum SearchEngineType: String, HandyJSONEnum {
    case google = "engine_google"
    case bing = "engine_bing"
    case yahooJapan = "engine_yahoo"
    case naver = "engine_naver"
    case yandex = "engine_yandex"   
    
    public func searchUrl() -> String {
        switch self {
        case .google:
            return "https://www.google.com/search?q=%@"
        case .bing:
            return "https://www.bing.com/search?q=%@"
        case .yahooJapan:
            return "https://search.yahoo.co.jp/search?p=%@"
        case .naver:
            return "https://search.naver.com/search.naver?query=%@"
        case .yandex:
            return "https://yandex.com/search/?text=%@"
        }
    }
    
    public func iconName() -> String {
        switch self {
        case .google:
            return "engine_google_icon"
        case .bing:
            return "engine_bing_icon"
        case .yahooJapan:
            return "engine_yahoo_icon"
        case .naver:
            return "engine_naver_icon"
        case .yandex:
            return "engine_yandex_icon"
        }
    }
    
    public func nameStr() -> String {
        switch self {
        case .google:
            return "Google"
        case .bing:
            return "Bing"
        case .yahooJapan:
            return "Yahoo"
        case .naver:
            return "Naver"
        case .yandex:
            return "Yandex"
        }
    }
    
}
