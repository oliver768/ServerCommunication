//
//  CALayer.swift
//  TonnijAppNew
//
//  Created by Aditya Sharma on 12/11/19.
//  Copyright © 2019 Mohit Chaudhary. All rights reserved.
//

import UIKit

public extension CALayer {
    
    func applySketchShadow( color: UIColor = .gray, alpha: CGFloat = 0.3, x: CGFloat = 0, y: CGFloat = 0, blur: CGFloat = ShadowValueConstants.shadowBlur.value, spread: CGFloat = 0.3) {
        shadowColor = color.cgColor
        shadowOpacity = Float(alpha)
        shadowOffset = CGSize(width: x, height: y)
        if spread == 0 {
            shadowPath = nil
        } else {
            rasterizationScale = spread
        }
    }
    
    func applyBottomSketchShadow() {
        self.applySketchShadow(color: UIColor(hex : "E2E0E0"), alpha: ShadowValueConstants.shadowAlpha.value, x: 0, y: -4, blur: ShadowValueConstants.shadowBlur.value, spread: ShadowValueConstants.shadowSpread.value)
    }
    
    func applyTopSketchShadow() {
        self.applySketchShadow(color: .gray, alpha: 1.0, x: 0, y: 4, blur: ShadowValueConstants.shadowBlur.value, spread: 1)
    }
    
    func removeSketchShadow() {
        self.applySketchShadow(color: .clear, alpha: 1, x: 0, y: 0, blur: 0, spread: 0)
    }
}

public extension UIColor {
    
    convenience init(hex: String) {
        self.init(hex: hex, alpha:1)
    }
    
    convenience init(hex: String, alpha: CGFloat) {
        var hexWithoutSymbol = hex
        if hexWithoutSymbol.hasPrefix("#") {
            hexWithoutSymbol = hex.substring(1)
        }
        
        let scanner = Scanner(string: hexWithoutSymbol)
        var hexInt:UInt32 = 0x0
        scanner.scanHexInt32(&hexInt)
        
        var r:UInt32!, g:UInt32!, b:UInt32!
        switch (hexWithoutSymbol.count) {
        case 3: // #RGB
            r = ((hexInt >> 4) & 0xf0 | (hexInt >> 8) & 0x0f)
            g = ((hexInt >> 0) & 0xf0 | (hexInt >> 4) & 0x0f)
            b = ((hexInt << 4) & 0xf0 | hexInt & 0x0f)
            break;
        case 6: // #RRGGBB
            r = (hexInt >> 16) & 0xff
            g = (hexInt >> 8) & 0xff
            b = hexInt & 0xff
            break;
        default:
            // TODO:ERROR
            break;
        }
        
        self.init(
            red: (CGFloat(r)/255),
            green: (CGFloat(g)/255),
            blue: (CGFloat(b)/255),
            alpha:alpha)
    }
}
