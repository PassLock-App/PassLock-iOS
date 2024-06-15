//
//  PassHealthStatus.swift
//  PassLock
//
//  Created by Melo on 2024/5/30.
//

import KakaFoundation

enum PassHealthStatus: Int {
    case tooBad = 0
    case justPassed = 1
    case excellent = 2
    case bestOfBest = 3
    
    func gradColors() -> [CGColor] {
        switch self {
        case .tooBad:
            return [UIColor.red.cgColor, UIColor.yellow.cgColor]
        case .justPassed:
            return [UIColor.orange.cgColor, UIColor.yellow.cgColor]
        case .excellent:
            return [UIColor.systemGreen.cgColor, UIColor.orange.cgColor]
        case .bestOfBest:
            return [UIColor.rgb(159, 254, 191).cgColor, UIColor.systemGreen.cgColor]
        }
    }
    
    func statusTitle() -> String {
        switch self {
        case .tooBad: return "terrible".localStr()
        case .justPassed: return "not bad".localStr()
        case .excellent: return "Excellent".localStr()
        case .bestOfBest: return "Optimal".localStr()
        }
    }
    
    func emojiTitle() -> String {
        switch self {
        case .tooBad: return "😂"
        case .justPassed: return "🥺"
        case .excellent: return "😀"
        case .bestOfBest: return "😆"
        }
    }
    
}
