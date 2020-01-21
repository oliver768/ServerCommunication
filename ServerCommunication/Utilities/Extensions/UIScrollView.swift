//
//  UIScrollView.swift
//  TonnijAppNew
//
//  Created by Aditya Sharma on 12/11/19.
//  Copyright © 2019 Mohit Chaudhary. All rights reserved.
//

import UIKit

public extension UIScrollView {
    func addRefreshControl(_ block:@escaping ()->()) {
        self.addSubview(FNRefreshControl().addRefreshControl(block))
    }
}
