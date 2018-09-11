//
//  UIColorExtension.swift
//  MotorDiary
//
//  Created by lex on 10/09/2018.
//  Copyright © 2018 alcherk. All rights reserved.
//

import UIKit

extension UIColor {
    
    static var navBarColor: UIColor {
        get { return UIColor.init(rgb: 0xEA3029) }
    }
    
    static var diaryChecked: UIColor {
        get { return UIColor.init(rgb: 0xEDEDEE) }
    }
    
    static var diaryEmpty: UIColor {
        get { return UIColor.init(rgb: 0xF7F7F7) }
    }
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
