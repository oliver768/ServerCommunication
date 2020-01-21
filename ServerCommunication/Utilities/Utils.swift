//
//  Utils.swift
//  TonnijAppNew
//
//  Created by Aditya Sharma on 12/10/19.
//  Copyright © 2019 Mohit Chaudhary. All rights reserved.
//



import UIKit
import Photos
let errorToastViewTag = 10002

class Utils{
    
    public class func window() -> UIWindow? {
        if #available(iOS 13.0, *) {
            let scene = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            guard let window = scene else {
                return nil
            }
            return window
        } else {
            return UIApplication.shared.delegate?.window ?? nil
        }
    }
    
    public class func navigationController() -> UINavigationController {
        return Utils.window()?.rootViewController as! UINavigationController
    }
    
//    public class func currentController(_ controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController {
//        if let navigationController = controller as? UINavigationController {
//            return currentController(navigationController.visibleViewController)
//        }
//        if let tabController = controller as? UITabBarController {
//            if let selected = tabController.selectedViewController {
//                return currentController(selected)
//            }
//        }
//        if let presented = controller?.presentedViewController {
//            return currentController(presented)
//        }
//        return controller is BaseViewController ? controller as! BaseViewController : Utils.navigationController().viewControllers.last as! BaseViewController
//    }
//
//    public class func showNetworkAlert( _ error : Error , closure : (([String : Any]) ->Void)? = nil){
//        FOLoader.shared.remove()
//        //Default Network Alert Page.
//        let controller = NetworkAlertVC()
//        let topController = UIApplication.topViewController()
//        if topController is TonnijLauncherVC {
//            topController?.addErrorToast("No Network connection found.")
//            closure?(ServerComm.shared.errorDict(error.localizedDescription))
//        }else{
//            topController?.presentVC(controller)
//        }
//    }
    
    /**
     Another complicated function.
     - Returns: none
     - Note: check aaccessability of photo library if not determin then request for permition.
     */
    public class func checkPhotoLibraryPermission() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            break
        case .denied, .restricted :
            break
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization() { status in
                switch status {
                case .authorized:
                    break
                case .denied, .restricted:
                    break
                case .notDetermined:
                    break
                default:
                    break
                }
            }
        default:
            break
        }
    }
    
    /**
     Another complicated function.
     - Returns: Boolean
     - Note: Check for Photo Library services enable from device.
     */
    
    public class func canAccessPhotoLibrary() -> Bool{
        var result = true
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            result = true
        case .denied, .restricted :
            result = false
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization() { status in
                switch status {
                case .authorized:
                    result = true
                case .denied, .restricted:
                    result = false
                case .notDetermined:
                    result = false
                default:
                    result = false
                }
            }
        default:
            return false
        }
        if !result {
//            Utils.currentController().showAlertMessage(message: "This app does not have access to your Photo Library. You can enable access in Privacy Settings.")
            return false
        }else{
            return true
        }
    }
    
    /**
     Another complicated function.
     - Returns: none
     - Note: check aaccessability of Camera if not determin then request for permition.
     */
    
    public class func checkCameraPermission(){
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .authorized:
            break
        case .denied, .restricted :
            break
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted :Bool) -> Void in
                switch status {
                case .authorized:
                    break
                case .denied, .restricted :
                    break
                case .notDetermined:
                    break
                default:
                    break
                }
            });
        default:
            break
        }
    }
    
    /**
     Another complicated function.
     - Returns: Boolean
     - Note: Check for Camera services enable from device.
     */
    public class func canAccessCamera() -> Bool{
        var result = false
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch status {
        case .authorized:
            result = true
        case .denied, .restricted :
            result = false
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted :Bool) -> Void in
                switch status {
                case .authorized:
                    result = true
                case .denied, .restricted :
                    result = false
                case .notDetermined:
                    result = false
                default:
                    result = false
                }
            });
        default:
            return false
        }
        if !result {
//            Utils.currentController().showAlertMessage(message: "This app does not have access to your camera. You can enable access in Privacy Settings.")
            return false
        }else{
            return canAccessPhotoLibrary()
        }
    }
    
    //MARK:- To add done button above textfield
    public class func btnAddDone(_ controller : UIViewController, doneAction:@escaping ()->()) -> UIToolbar {
        let keyboardToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 40))
        keyboardToolBar.barStyle = .default
        keyboardToolBar.tintColor = UIColor.white
        let btnDone = UIBlockButton(frame: CGRect(x: 10, y: 5, width: 60, height: 30))
        btnDone.setTitle("Done", for: .normal)
        btnDone.backgroundColor = UIColor.lightGray
        btnDone.layer.cornerRadius = 3.0
        btnDone.handleControlEvents(.touchUpInside) {
            doneAction()
        }
        let flex = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: controller, action: nil)
        let rightBarButton = UIBarButtonItem(customView: btnDone)
        keyboardToolBar.setItems([flex,flex,rightBarButton], animated: true)
        return keyboardToolBar
    }
    
    public class func addErrorToast(_ errorMessage : String){
        let window = Utils.window()!
        let errorViewToRemove = window.viewWithTag(errorToastViewTag)
        if(errorViewToRemove != nil){
            return
        }
        let errorView = UIView.init(frame: CGRect(x: 0, y: NAVIGATION_HEIGHT, width: UIScreen.main.bounds.size.width,  height: DeviceInfo.pad ? 60 : 44))
        errorView.backgroundColor = ColorConstants.red.color
        errorView.tag = errorToastViewTag
        let errorLabel = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width,  height: DeviceInfo.pad ? 60 : 44))
        errorLabel.font = UIFont(name: "OpenSans-Semibold", size: DeviceInfo.pad ? 20.0 : 14.0)
        errorLabel.textAlignment = NSTextAlignment.center
        errorLabel.numberOfLines = 2
        errorLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        errorLabel.textColor = UIColor.white
        errorLabel.text = errorMessage
        errorLabel.accessibilityIdentifier = "error_msg"
        errorView.addSubview(errorLabel)
        window.addSubview(errorView)
        Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(removeErrorToast), userInfo: nil, repeats: false)
    }
    
    @objc public class func removeErrorToast(){
        let window = Utils.window()!
        let errorViewToRemove = window.viewWithTag(errorToastViewTag)
        errorViewToRemove?.removeFromSuperview()
    }
    
    //MARK:- Return Attributed String
    
    public class func attributedString (firstString : String, secondString : String, fontSize : Int, firstStringColor : UIColor? = nil, secondStringColor : UIColor? = nil, firstStringFont: String? = nil, secondStringFont: String? = nil ) -> NSAttributedString {
        let myString = firstString
        let firstColor = (firstStringColor == nil ? ColorConstants.darkGray.color : firstStringColor)!
        let font1 = (firstStringFont == nil ? UIFont(name: "OpenSans-Semibold", size: CGFloat(fontSize))! : UIFont(name: firstStringFont ?? "OpenSans-Semibold", size: CGFloat(fontSize))!)
        let myAttribute  = [NSAttributedString.Key.font : font1, NSAttributedString.Key.foregroundColor : firstColor]
        let secondColor = (secondStringColor == nil ? UIColor.darkGray : secondStringColor)!
        let font2 = (secondStringFont == nil ? UIFont(name: "OpenSans", size: CGFloat(fontSize))! : UIFont(name: secondStringFont ?? "OpenSans", size: CGFloat(fontSize))!)
        let yourOtherAttributes = [NSAttributedString.Key.font : font2, NSAttributedString.Key.foregroundColor : secondColor]
        let partOne = NSMutableAttributedString(string: myString, attributes: myAttribute)
        let partTwo = NSMutableAttributedString(string: secondString , attributes: yourOtherAttributes)
        let combination = NSMutableAttributedString()
        combination.append(partOne)
        combination.append(partTwo)
        return combination
    }
}

public class UIBlockButton: UIButton {
    var action : (()->())?
    func handleControlEvents(_ events:UIControl.Event, withCompletionBlock block:@escaping ()->()) {
        action = block
        self.addTarget(self, action: #selector(UIBlockButton.btnActionDone(_:)), for: events)
    }
    @objc func btnActionDone(_ sender:AnyObject) {
        action!()
    }
}

public class FNRefreshControl: UIRefreshControl {
    var action : (()->())?
    func addRefreshControl(_ block:@escaping ()->()) -> UIRefreshControl {
        action = block
        self.tintColor = .orange
        self.addTarget(self, action: #selector(FNRefreshControl.loadRefreshing), for: .valueChanged)
        return self
    }
    @objc func loadRefreshing() {
        action!()
        self.endRefreshing()
    }
}

