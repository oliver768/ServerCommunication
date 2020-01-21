//
//  RequestParam.swift
//  ServerCommunication
//
//  Created by Ravindra Sonkar on 21/01/20.
//  Copyright © 2020 Ravindra Sonkar. All rights reserved.
//

import UIKit

open class RequestParam: NSObject {
    
    private var postParamHash = [String : Any]()
    private var postParamList = [Any]()
    open var isProgressLoaderHidden = false
    open var requestType = "POST"
    open var contentType = "application/x-www-form-urlencoded; charset=utf-8"
    var isParamList = false
    var queryItemList : [URLQueryItem]!
    
    override public init() {
        
    }
    
    // INIT with action id will add action id to queryParamHash itself
    public convenience init(_ value : Any?, forKey key: String) {
        self.init()
        addPostParam(value, forKey: key)
    }
    
    public convenience init(_ list : [Any]) {
        self.init()
        isParamList = true
        postParamList = list
    }
    
    /**
     - Parameter value and key
     - Requires: both params are required.
     - Note: This will add value to queryParamHash
     */
    open func addPostParam (_ value : Any?, forKey key: String) {
        if value != nil{
            postParamHash[key] = value
        }
    }
    
    /**
     - Parameter value and key
     - Requires: both params are required.
     - Note: This will add value to Multiple value to object hash. replaceOldValues will manage to replace the conflicted keys
     */
    public func addPostParams (_ postHash : [String : Any]?, replaceOldValues : Bool = true) {
        if postHash != nil{
            self.postParamHash = replaceOldValues ? self.postParamHash.merging(postHash!) { (_, new) in new } : self.postParamHash.merging(postHash!) { (current, _) in current }
        }
    }
    
    //Add Query Items
    open func addQueryItem (_ value : String?, forKey key: String) {
        if queryItemList == nil {
            queryItemList = [URLQueryItem]()
        }
        if value != nil{
            queryItemList.append(URLQueryItem(name: key, value: value))
        }
    }
    
    /**
     - Returns: requestHash
     - Note: This will give the request hash having keys: queryParamHash,objectHash,selectedObjectHash
     */
    private func requestHash () -> Any {
        return isParamList ? postParamList : postParamHash
    }
    
    func addQueryParamToList () {
        if isParamList{
            postParamList.append(postParamHash)
            postParamHash.removeAll()
        }
    }
    
    /**
     - Returns: requestHash
     - Note: This will give the json string of request hash having keys: queryParamHash,objectHash,selectedObjectHash
     */
    open func requestHashJson() -> String {
        return jsonStringWithJSONObject(requestHash())!
    }
    
    private func jsonStringWithJSONObject(_ jsonObject: Any) -> String? {
        let data: Data? = try? JSONSerialization.data(withJSONObject: jsonObject, options: JSONSerialization.WritingOptions.prettyPrinted)
        var jsonStr: String?
        if data != nil {
            jsonStr = String(data: data!, encoding: String.Encoding.utf8)
        }
        return jsonStr
    }
    
}
