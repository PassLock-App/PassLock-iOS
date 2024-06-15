//
//  Reasource.swift
//  Kaka
//
//  Created by Kaka Inc.on 2021/12/19.
//

import UIKit
import AppGroupKit

public class Reasource {
  
  public static func named(_ name: String) -> UIImage {
      let bundle = self.imagePath()
      
      guard let filePath = bundle.path(forResource: "Images/" + name + "@3x.png", ofType: nil), let image = UIImage(contentsOfFile: filePath) else {
          return UIImage(color: UIColor.random(), size: CGSize(width: 1, height: 1))!
      }
    
      return image
  }
    
    public static func mediaUrl(_ name: String) -> String {
      let bundle = self.mediaPath()

      guard let filePath = bundle.path(forResource: "Media/" + name, ofType: nil) else {
          return ""
      }

      return filePath
    }
    
    public static func vipNamed(_ name: String) -> UIImage? {
        let bundle = self.imagePath()
        
        guard let filePath = bundle.path(forResource: "VIP/" + name + "@3x.png", ofType: nil), let image = UIImage(contentsOfFile: filePath) else {
            return nil
        }
      
        return image
    }

  private static func imagePath() -> Bundle {
      let bundlePath = Bundle.main.path(forResource: "Reasource", ofType: "bundle")!
      return Bundle(path: bundlePath)!
  }
  
    private static func mediaPath() -> Bundle {
        let bundlePath = Bundle.main.path(forResource: "Reasource", ofType: "bundle")!
        return Bundle(path: bundlePath)!
    }
  
}

extension Reasource {
    
    public static func systemNamed(_ name: String, color: UIColor = UIColor.systemBlue) -> UIImage {
        let isDark = UITraitCollection.current.userInterfaceStyle == .dark
        let config = UITraitCollection(userInterfaceStyle: isDark ? .dark : .light)
        
        let image = UIImage(systemName: name, compatibleWith: config)
                
        return image?.withRenderingMode(.alwaysOriginal).withTintColor(color) ?? UIImage()
    }
    
}

extension Reasource {
    public static func svgFileUrl(_ name: String) -> String {
      let bundle = self.mediaPath()

      guard let filePath = bundle.path(forResource: "SVG/" + name, ofType: "svg") else {
          return ""
      }

      return filePath
    }
}

