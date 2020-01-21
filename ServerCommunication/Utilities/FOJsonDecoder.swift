//
//  FOJsonDecoder.swift
//  ServerCommunication
//
//  Created by Ravindra Sonkar on 21/01/20.
//  Copyright © 2020 Ravindra Sonkar. All rights reserved.
//

import UIKit

public class FOJsonDecoder {
    
    private class func parseJsonData<T: Decodable>(_ classDeclared : T.Type , jsonDict : NSDictionary) -> Any? {
        let tempData = NSKeyedArchiver.archivedData(withRootObject: jsonDict)
        var tempObj : Any!
        do {
            tempObj = try JSONDecoder().decode(classDeclared, from: tempData)
        } catch let er {
            print(er)
        }
        return tempObj
    }
    
    private class func parseJsonArray<T: Decodable>(_ classDeclared : T.Type , jsonArray : NSArray) -> Any? {
        let returnArray = NSMutableArray()
        for i in 0 ..< jsonArray.count {
            let dict: AnyObject = jsonArray.object(at: i) as AnyObject
            returnArray.add(parseJsonData(classDeclared, jsonDict: dict as! NSDictionary)!)
        }
        return returnArray
    }
    
    class var blankObject : [String : Any] { get{ return ["isBlank" : true] } }
    
    public class func decodeJSON<T: Decodable>(_ classDeclared : T.Type , json : Any) -> Any? {
        guard let tempJSON =  json as? NSDictionary else {
            var returnArray = [Any]()
            for item in (json as? [Any]) ?? [] {
                returnArray.append(decodeJSON(classDeclared, json: item)!)
            }
            return returnArray
        }
        let tempData = tempJSON.toData()
        var tempObj : Any!
        do {
            let decoder = JSONDecoder()
            if #available(iOS 10.0, *) {
                decoder.dateDecodingStrategy = .iso8601
            } else {
                // Fallback on earlier versions
            }
            tempObj = try decoder.decode(classDeclared, from: tempData)
        } catch let er {
            print(er)
            print(er)
        }
        return tempObj
    }
    
    private class func encodeToData<T: Encodable>(_ object : T) -> Data? {
        var tempObj : Data!
        do {
            let encoder = JSONEncoder()
            if #available(iOS 10.0, *) {
                encoder.dateEncodingStrategy = .iso8601
            } else {
                // Fallback on earlier versions
            }
            tempObj = try encoder.encode(object)
        } catch let er {
            print(er)
        }
        return tempObj
    }
    
    public class func encodeObject<T: Encodable>(_ object : T) -> Any? {
        if let data = FOJsonDecoder.encodeToData(object){
            return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
        }
        return nil
    }
}


import UIKit

public extension NSDictionary{
    
    func toJSONString() -> String{
        if JSONSerialization.isValidJSONObject(self) {
            do{
                let data = try JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions(rawValue: 0))
                if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                    return string as String
                }
            }catch let err {
                print(err)
            }
        }
        return ""
    }
    
    func toData() -> Data{
        if JSONSerialization.isValidJSONObject(self) {
            do{
                let data = try JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions(rawValue: 0))
                return data
            }catch let err {
                print(err)
            }
        }
        return Data()
    }
}
