//
//  AppICloudManager+Tool.swift
//  AppGroupKit
//
//  Created by Melo on 2024/1/13.
//

import Foundation

extension AppICloudManager {
    
    func filterStringArray(arrayA: [String], notContainingIn arrayB: [String]) -> [String] {
        let filteredArray = arrayA.filter { elementA in
            let containsInB = arrayB.contains { elementB in
                elementA.contains(elementB)
            }

            return !containsInB
        }
        
        return filteredArray
    }
    
}
