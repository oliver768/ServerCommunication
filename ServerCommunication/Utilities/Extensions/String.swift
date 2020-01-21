//
//  String.swift
//  TonnijAppNew
//
//  Created by Aditya Sharma on 12/10/19.
//  Copyright © 2019 Mohit Chaudhary. All rights reserved.
//

import UIKit

extension String {
    
    static  func className(_ aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last!
    }
    
    func removingLeadingSpaces() -> String {
        guard let index = firstIndex(where: { !CharacterSet(charactersIn: String($0)).isSubset(of: .whitespaces) }) else {
            return self
        }
        return String(self[index...])
    }
    
    var firstLetterUpperCase:String {
        var result = Array(self)
        if let first = self.first { result[0] = Character(String(first).uppercased()) }
        return String(result)
    }
    
    func replace(_ string:String, replacement:String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
    }
    
    func removeWhitespace() -> String {
        return self.replace(" ", replacement: "")
    }
    
    var removeExcessiveSpaces: String {
        let components = self.components(separatedBy: CharacterSet.whitespacesAndNewlines)
        let filtered = components.filter({!$0.isEmpty})
        return filtered.joined(separator: " ")
    }
    
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return boundingBox.height
    }
    
//    func convertToDictionary() -> [String: Any]? {
//        if let data = self.data(using: .utf8) {
//            do {
//                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
//            } catch let err {
//                ExceptionUtil.saveException(err)
//            }
//        }
//        return nil
//    }
//
//    func convertBase64ToDictionary() -> [String: Any]? {
//        return convertBase64ToString()?.convertToDictionary()
//    }
    
    func convertBase64ToString() -> String? {
        let decodedData = Data(base64Encoded: self)!
        let decodedString = String(data: decodedData, encoding: .utf8)!
        return decodedString
    }
    
    func heightForLabel(_ font: UIFont, width: CGFloat, lineSpacing: CGFloat) -> CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        if lineSpacing > 0.0 {
            let style = NSMutableParagraphStyle()
            style.lineSpacing = lineSpacing
            style.alignment = .center
            label.attributedText = NSAttributedString(string: self, attributes: [NSAttributedString.Key.paragraphStyle: style])
        } else {
            label.text = self
        }
        label.sizeToFit()
        return label.frame.height
    }
    
    func heightForView(_ font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = font
        label.text = self
        label.sizeToFit()
        return label.frame.height
    }
    
    func matches(_ withRegex: String) -> Bool {
        return NSPredicate(format:"SELF MATCHES %@", withRegex).evaluate(with: self)
    }
    
    func trimPrefixes(_ initialCharToTrim: Character) -> String {
        var result = ""
        for character in self {
            if result.isEmpty && character == initialCharToTrim { continue }
            result.append(character)
        }
        return result
    }
    
    var formatedNumber: NSNumber {
        let numberFormatter = NumberFormatter()
        numberFormatter.decimalSeparator = "."
        if let result = numberFormatter.number(from: self) {
            return result
        } else {
            numberFormatter.decimalSeparator = ","
            if let result = numberFormatter.number(from: self) {
                return result
            }
        }
        return 0
    }
    
    func substring(_ from: Int) -> String {
        return String(self[self.index(self.startIndex, offsetBy: from)...])
    }
    
    func substringWithRange(_ start: Int, end: Int) -> String{
        if (start < 0 || start > self.count){
            return ""
        }else if end < 0 || end > self.count{
            return ""
        }
        let range = (self.index(self.startIndex, offsetBy: start) ..< self.index(self.startIndex, offsetBy: end))
        return String(self[range])
    }
    
    
    func substringWithRange(_ start: Int, location: Int) -> String{
        if (start < 0 || start > self.count){
            return ""
        }else if location < 0 || start + location > self.count{
            return ""
        }
        let range = (self.index(self.startIndex, offsetBy: start) ..< self.index(self.startIndex, offsetBy: start + location))
        return String(self[range])
    }
    
    var isBlank : Bool {
        get{
            return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).replacingOccurrences(of: " ", with: "").count == 0
        }
    }
        
    func isEmptyString () -> Bool {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).replacingOccurrences(of: " ", with: "").count == 0
    }
    
}
