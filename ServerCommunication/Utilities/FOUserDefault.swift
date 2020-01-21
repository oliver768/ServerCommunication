//
//  FOUserDefault.swift
//  ServerCommunication
//
//  Created by Ravindra Sonkar on 21/01/20.
//  Copyright © 2020 Ravindra Sonkar. All rights reserved.
//

import UIKit

class FOUserDefault: NSObject {
    
    class var singleton: FOUserDefault {
        struct Static {
            static let instance = FOUserDefault()
        }
        return Static.instance
    }
    open func userDefault() -> UserDefaults{
        return UserDefaults.standard
    }
    
    open func userName() -> String?{
        return userDefault().object(forKey: "USER_NAME") as? String
    }
    
    open func password() ->String?{
        return userDefault().object(forKey: "PASSWORD") as? String
    }
    
    open func deviceToken() -> String?{
        return userDefault().object(forKey: "DEVICE_TOKEN") as? String
    }
    
    open func authToken() -> String?{
        return userDefault().object(forKey: "AUTH_TOKEN") as? String
    }
    
    open func setDeviceToken(_ deviceToken : String){
        userDefault().set(deviceToken, forKey: "DEVICE_TOKEN")
    }
    
    open func setAuthToken(_ authToken : String){
        userDefault().set(authToken, forKey: "AUTH_TOKEN")
    }
    
    open func setUserName(_ userName : String){
        userDefault().set(userName, forKey: "USER_NAME")
        //        keyChain.set(userName, forKey: "USER_NAME")
    }
    
    open func setPassword(_ password : String){
        userDefault().set(password, forKey: "PASSWORD")
        //        keyChain.set(password, forKey: "PASSWORD")
    }
    
    open func isUserCredentialSaved() -> Bool{
        if(userName() == nil || password() == nil){
            return false
        }
        return true
    }
    
    open func removeUserName(){
        userDefault().removeObject(forKey: "USER_NAME")
    }
    
    open func removePassword(){
        userDefault().removeObject(forKey: "PASSWORD")
    }
    
    open func removeUserCredential(){
        self.userDefault().removeObject(forKey: "PASSWORD")
        self.userDefault().removeObject(forKey: "USER_NAME")
    }
    
}
