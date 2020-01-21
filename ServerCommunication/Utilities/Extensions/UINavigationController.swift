//
//  UINavigationController.swift
//  TonnijAppNew
//
//  Created by Aditya Sharma on 12/26/19.
//  Copyright © 2019 Mohit Chaudhary. All rights reserved.
//


import UIKit

extension UINavigationController {
    
    func getViewController(_ vc : AnyClass) -> UIViewController {
        for tempVC in self.viewControllers {
            if type(of: tempVC) == vc {
                return tempVC
            }
        }
        return self.viewControllers[0]
    }
    
    //    func popToViewController(_ vc : AnyClass, animated : Bool){
    //        popToViewController(getViewController(vc), animated: animated)
    //    }
    
    
    func pop(to controller : UIViewController, animated : Bool = true){
//        ModelManager.singleton.isDetailChanges = true
        self.popToViewController(controller, animated: animated)
    }
    
    func containsViewController(_ vc : AnyClass) -> (isExist: Bool, controller: UIViewController?) {
        let arr = viewControllers.filter { type(of: $0) == vc }
        return (arr.count != 0 , arr.first)
    }
    
}
