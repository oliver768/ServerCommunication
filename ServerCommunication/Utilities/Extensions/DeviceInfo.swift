//
//  DeviceInfo.swift
//  ServerCommunication
//
//  Created by Ravindra Sonkar on 21/01/20.
//  Copyright © 2020 Ravindra Sonkar. All rights reserved.
//

import Foundation
import UIKit
public extension UIDevice {
    
    var isSimulator: Bool {
        return TARGET_OS_SIMULATOR != 0
    }
}

public struct DeviceInfo {
    
    public static var isIphone5:Bool { return DeviceInfo.typeIsLike == .iphone5 }
    public static var width:CGFloat { return UIScreen.main.bounds.size.width }
    public static var height:CGFloat { return UIScreen.main.bounds.size.height }
    public static var maxLength:CGFloat { return max(width, height) }
    public static var minLength:CGFloat { return min(width, height) }
    public static var zoomed:Bool { return UIScreen.main.nativeScale >= UIScreen.main.scale }
    public static var retina:Bool { return UIScreen.main.scale >= 2.0 }
    public static var phone:Bool { return UIDevice.current.userInterfaceIdiom == .phone }
    public static var pad:Bool { return UIDevice.current.userInterfaceIdiom == .pad }
    public static var carplay:Bool { return UIDevice.current.userInterfaceIdiom == .carPlay }
    public static var tv:Bool { return UIDevice.current.userInterfaceIdiom == .tv }
    public static var isSimulator:Bool { return UIDevice.current.isSimulator }
    public static var statusBar:CGRect { if #available(iOS 13.0, *) {
        return Utils.window()?.windowScene?.statusBarManager?.statusBarFrame ?? UIApplication.shared.statusBarFrame
    } else {
        return UIApplication.shared.statusBarFrame
        }
    }
    public static var hasNotch: Bool {
        if #available(iOS 11.0, *) {
            let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
            return bottom > 0
        } else {
            return false
        }
    }
    
    public static var typeIsLike:DisplayType {
        if phone && maxLength < 568 {
            return .iphone4
        }
        else if phone && maxLength == 568 {
            return .iphone5
        }
        else if phone && maxLength == 667 {
            return .iphone6
        }
        else if phone && maxLength == 736 {
            return .iphone6plus
        }
        else if pad && !retina {
            return .iPadNonRetina
        }
        else if pad && retina && maxLength == 1024 {
            return .iPad
        }
        else if pad && maxLength == 1366 {
            return .iPadProBig
        }
        return .unknown
    }
    
    public struct Orientation {
        // indicate current device is in the LandScape orientation
        public static var isLandscape: Bool {
            get {
                return UIDevice.current.orientation.isValidInterfaceOrientation
                    ? UIDevice.current.orientation.isLandscape
                    : UIApplication.shared.statusBarOrientation.isLandscape
            }
        }
        // indicate current device is in the Portrait orientation
        public static var isPortrait: Bool {
            get {
                return UIDevice.current.orientation.isValidInterfaceOrientation
                    ? UIDevice.current.orientation.isPortrait
                    : UIApplication.shared.statusBarOrientation.isPortrait
            }
        }
    }
}

public enum DisplayType {
    case unknown
    case iphone4
    case iphone5
    case iphone6
    case iphone6plus
    case iPadNonRetina
    case iPad
    case iPadProBig
    static let iphone7 = iphone6
    static let iphone7plus = iphone6plus
}

public extension Bundle {
    
    var releaseVersion: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    var buildVersion: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
    
    var displayName: String? {
        return object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ??
            object(forInfoDictionaryKey: "CFBundleName") as? String
    }
}
