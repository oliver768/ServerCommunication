//
//  UITableView.swift
//  TonnijAppNew
//
//  Created by Aditya Sharma on 12/11/19.
//  Copyright © 2019 Mohit Chaudhary. All rights reserved.
//

import UIKit

public extension UITableView {
    override func addNoRecord(_ msg : String? = nil){
        let label = UILabel(frame: CGRect(x: 0, y: (self.frame.size.height/2)-15, width: self.frame.size.width, height: self.frame.size.height))
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.backgroundColor = ColorConstants.clear.color
        label.textColor = UIColor.lightGray
        label.font = UIFont(name: "OpenSans-Regular", size: DeviceInfo.pad ? 20.0 : 16.0)
        label.textAlignment = NSTextAlignment.center
        label.text = msg ?? "No Data To Display"
        label.isUserInteractionEnabled = true
        self.backgroundView = label
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapAction(_:)))
        self.backgroundView!.addGestureRecognizer(tapGesture)
    }
    
    override func removeNoRecord(){
        self.backgroundView = nil
        let blankView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        blankView.backgroundColor = ColorConstants.clear.color
        blankView.isUserInteractionEnabled = true
        self.backgroundView = blankView
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapAction(_:)))
        self.backgroundView!.addGestureRecognizer(tapGesture)
    }
    
    @objc func tapAction(_ sender : UITapGestureRecognizer){
//        UIApplication.shared.delegate.singleton.refreshTimerForSharedDevice()
    }


}
