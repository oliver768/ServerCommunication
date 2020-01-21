//
//  FOConstants.swift
//  ServerCommunication
//
//  Created by Ravindra Sonkar on 21/01/20.
//  Copyright © 2020 Ravindra Sonkar. All rights reserved.
//

import Foundation

import UIKit

//Parameters Names

let kJWTToken = "jwtToken"
let pToken = "token"
let pStatusCode = "status"
let pError = "error"
let pStatusCodeError = "statusCode"

let KAuthToken = "authToken"

public let NAVIGATION_HEIGHT = DeviceInfo.statusBar.height + 44

enum TimeFormat : String {
    
    case `default` = "dd-MM-yyyy"
    case server = "yyyy-MM-dd'T'HH:mm:ss"
    case serverInMicro = "yyyy-MM-dd'T'HH:mm:ss:SSS"
    
    var stringValue : String {
        return self.rawValue
    }
    
}

public enum ShadowValueConstants {
    
    case shadowAlpha
    case shadowBlur
    case shadowSpread
    case shadowOffsetX
    case shadowOffsetY
    
    public var value: CGFloat {
        switch self {
        case .shadowAlpha:
            return 1.0
        case .shadowBlur:
            return 10
        case .shadowSpread:
            return 1
        case .shadowOffsetX:
            return 3
        case .shadowOffsetY:
            return 3
        }
    }
}

public enum OrderStatus : String {
    
    case saved = "Saved"
    case loadSaved = "LoadSaved"
    case posted = "Posted"
    case confirmed = "Confirmed"
    case dispatched = "Dispatched"
    case delivered = "Delivered"
    case invoiced = "Invoiced"
    case fullyPaid = "Fully Paid"
    case partialPaid = "Partial Paid"
    case paid = "Paid"
    
    var stringValue : String{
        return self.rawValue
    }
}

public enum LoadFilter {
    case inTransit
    case delivered
    case all
}

public enum ColorConstants {
    case green
    case red
    case barTitleColor
    case headerColor
    case background
    case tableHeaderColor
    case evenIndexCellColor
    case oddIndexCellColor
    case textColorGrey
    case white
    case seperator
    case shadowColor
    case headerTextColor
    case skyBlue
    case clear
    case black
    case darkGray
    case lightGray
    case gray
    case orange
    case primaryOrange
    
    public var color: UIColor {
        switch self {
        case .green:
            return UIColor(hex : "5AD236")
        case .red:
            return .systemRed
        case .barTitleColor:
            return UIColor(hex: "638186")
        case .headerColor:
            return UIColor(hex : "DADADA")
        case .background:
            return UIColor(hex : "FCFBFA")
        case .tableHeaderColor:
            return UIColor(hex : "E9EBED")
        case .evenIndexCellColor:
            return UIColor(hex : "F4F4F5")
        case .oddIndexCellColor:
            return UIColor(hex : "FFFFFF")
        case .textColorGrey:
            return UIColor(hex : "737680")
        case .white:
            return UIColor(hex : "FFFFFF")
        case .seperator:
            return UIColor(hex : "E9EBED")
        case .shadowColor:
            return UIColor(hex : "E2E0E0")
        case .headerTextColor:
            return UIColor(hex: "9599A1")
        case .skyBlue:
            return UIColor(hex: "35C4FF")
        case .black:
            return UIColor(hex: "000000")
        case .darkGray:
            return UIColor(hex: "434343")
        case .clear:
            return UIColor(white: 1, alpha: 0)
        case .lightGray:
            return UIColor(hex: "9A9A9A")
        case .gray:
            return UIColor(hex: "8e8e93")
        case .orange:
            return UIColor(hex: "FF9672")
        case .primaryOrange:
            return UIColor(hex: "F15D2A")
        }
    }
    
    public var cgColor : CGColor {
        return color.cgColor
    }
}


