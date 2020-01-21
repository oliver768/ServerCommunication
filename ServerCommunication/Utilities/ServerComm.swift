//
//  ServerComm.swift
//  ServerCommunication
//
//  Created by Ravindra Sonkar on 03/01/20.
//  Copyright © 2020 Ravindra Sonkar. All rights reserved.
//

import Foundation
import UIKit

typealias SuccessBlockType = (Any) ->Void
typealias FailureBlockType = ([String : Any]) ->Void

open class ServerComm : NSObject {
    
    public var redirectURL : String?
    var expMgmtUrl: String?
    var expMgmtAPIKey: String?
    var currentRequest: URLRequest?
    var successBlock : SuccessBlockType!
    var failureBlock : FailureBlockType!
    
    open class var shared: ServerComm {
        struct Static {
            static let instance = ServerComm()
        }
        URLCache.shared = {
            URLCache(memoryCapacity: 0, diskCapacity: 0, diskPath: nil)
        }()
        URLCache.shared.removeAllCachedResponses()
        return Static.instance
    }
    
    open func initialPathUrl() -> String{
        return "https://tonnijapi.nijomee.com/api/"
    }
    
    func authAjaxUrl(_ relativeURL : String)-> String {
        return "\(initialPathUrl())\(relativeURL)"
    }
    
    public func doRequest(_ relativeURL : String, RequestParam : RequestParam? = nil,isGetRequest : Bool? = false, success:@escaping (Any)-> Void, failure: (([String : Any]) ->Void)? = nil){
        let urlString = self.authAjaxUrl(relativeURL)
        self.request(urlString, contentType: nil, RequestParam: RequestParam,isGetRequest: isGetRequest , success: success, failure: failure)
    }
    
    public func request(_ urlString:String, contentType : String?, RequestParam : RequestParam? = nil,isGetRequest : Bool? = false,  success:@escaping (Any)->Void, failure:(([String : Any]) ->Void)? = nil) {
        if let _ = isGetRequest {
            DispatchQueue.main.async {
                FOLoader.shared.add()
            }
        }
        if !(RequestParam?.isProgressLoaderHidden ?? true){
            FOLoader.shared.add()
        }
        let url: URL?
        var urlComponent = URLComponents(string: urlString.removeWhitespace())!
        urlComponent.queryItems = RequestParam?.queryItemList ?? []
        url = urlComponent.url
        print("URL :::: \(url!)")
        print("Post String ::::: \(String(describing: RequestParam?.requestHashJson()))")
        let request = NSMutableURLRequest(url: url!, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 90.0)
        if RequestParam != nil {
            let postBody = RequestParam?.requestHashJson().data(using: String.Encoding.utf8, allowLossyConversion: true)
            let contentType = contentType ?? "application/x-www-form-urlencoded; charset=utf-8"
            request.addValue(contentType, forHTTPHeaderField: "Content-Type")
            let contentLength = "\(String(describing: postBody?.count))"
            request.addValue(contentLength, forHTTPHeaderField: "Content-Length")
            request.addValue(UIDevice.current.systemVersion, forHTTPHeaderField: "deviceOS")
            request.addValue(UIDevice.current.model, forHTTPHeaderField: "deviceModel")
            if FOUserDefault.singleton.authToken() != nil{
                request.addValue("Bearer " + FOUserDefault.singleton.authToken()!, forHTTPHeaderField: "Authorization")
            }
            request.httpMethod = "POST"
            request.httpBody = postBody
        }else{
            request.httpMethod = "GET"
        }
        self.requestWithHttpRequest(request as URLRequest, RequestParam: RequestParam,isGetRequest: isGetRequest, success: success, failure: failure)
    }
    
    public func  processPendingRequest(){
        FOLoader.shared.add()
        self.requestWithHttpRequest(currentRequest!, success: successBlock, failure: failureBlock)
    }
    
    public func requestWithHttpRequest(_ urlRequest :URLRequest, RequestParam : RequestParam? = nil, isGetRequest : Bool? = false, success:@escaping (Any)->Void, failure: (([String : Any]) ->Void)? = nil){
        self.currentRequest = urlRequest
        self.successBlock = success
        if failure != nil { self.failureBlock = failure }
        
        func initiateRequest(){
            URLSession.shared.dataTask(with: urlRequest, completionHandler: {(data, response, error)  -> Void in
                DispatchQueue.main.async {
                    if error != nil {
                        if !(RequestParam?.isProgressLoaderHidden ?? false) {
                            if (!(RequestParam?.isProgressLoaderHidden ?? true) || (isGetRequest ?? false)) {
                                FOLoader.shared.remove()
                            }
                            //Add Alert PopUp for Network error
                            //                            Utils.showNetworkAlert(error!, closure: failure)
                        }
                    }else{
                        //Handle Failure
                        func handleFailure(_ failureDict : [String : Any]){
                            if failure == nil {
                                //Add Currentcontroller for showing error toast
                                //                                Utils.currentController().addErrorToast(failureDict["Message"] as! String)
                            }else{
                                failure!(failureDict)
                            }
                        }
                        
                        let urlResponse = response as! HTTPURLResponse
                        if !(urlResponse.statusCode == 200 || urlResponse.statusCode == 201) && !(RequestParam?.isProgressLoaderHidden ?? true) {
                            let result = self.successDict(data!)
                            handleFailure(result.serializedObject as! [String : Any])
                        }else{
                            let result = self.successDict(data!)
                            if result.isSuccess {
                                success(result.serializedObject)
                            }else{
                                handleFailure(result.serializedObject as! [String : Any])
                            }
                        }
                    }
                    if (!(RequestParam?.isProgressLoaderHidden ?? true) || (isGetRequest ?? false)) {
                        FOLoader.shared.remove()
                    }
                }
            }).resume()
        }
        
        if !(RequestParam?.isProgressLoaderHidden ?? true) {
            initiateRequest()
        }else{
            DispatchQueue.main.async {
                initiateRequest()
            }
        }
        
    }
    
    //MARK:- This function return message string
    /**
     - Parameters:
     - Returns: Error Message
     - Note: This method return message id IsError, isWarning or isPageRefresh true.
     */
    func getErrorString(jsonDict: [String : Any]) -> String{
        if let msg = jsonDict["Message"] as? String {
            return msg
        }else{
            return "Error"
        }
    }
    
    public func successDict(_ data : Data) -> (isSuccess : Bool, serializedObject : Any){
        do{
            let json = try JSONSerialization.jsonObject(with: data, options:.allowFragments)
            print(json)
            if let result = json as? [String : Any], let resultStatus = result["Status"] as? String {
                return resultStatus == "error" ? (false, errorDict((result["Message"] as? String) ?? "Something went wrong")) : (true, json)
            }else{
                return (true, json)
            }
        }catch let err{
            let json = errorDict(err.localizedDescription)
            return (false, json)
        }
    }
    
    public func errorDict(_ aMessage : String) -> [String : Any]{
        let customError = "{\"isError\":1,\"Message\":\"\(aMessage)\"}"
        return try! JSONSerialization.jsonObject(with: customError.data(using: String.Encoding.utf8)!, options:JSONSerialization.ReadingOptions.allowFragments) as! [String : Any]
    }
    
    //MARK:- Logout Request
    
    func logoutApp(){
        //        AltaUserDefault.singleton.removeUserCredential()
        //        ModelManager.singleton.resetModelData()
        //        DispatchQueue.main.async(execute: { () -> Void in
        //            DataUtils.removeLoadIndicator()
        //            AppDelegateManager.singleton.loadLoginPage()
        //        })
    }
    
}

extension ServerComm : URLSessionDelegate {
    
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
    }
}

extension NSMutableData {
    public func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}

