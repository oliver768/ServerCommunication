//
//  FOLoader.swift
//  ServerCommunication
//
//  Created by Ravindra Sonkar on 21/01/20.
//  Copyright © 2020 Ravindra Sonkar. All rights reserved.
//

import UIKit

class FOLoaderView: UIView {
    
    public class var shared: FOLoaderView {
          struct Static {
              static let instance = FOLoaderView()
          }
          return Static.instance
      }
    
    convenience init() {
        self.init(frame: CGRect(x: 30, y: (DeviceInfo.height - 60)/2, width: DeviceInfo.width - 60, height: 60))
        self.setup()
    }

       override public init(frame: CGRect) {
           super.init(frame: frame)
           self.setup()
       }

       public required init?(coder aDecoder: NSCoder) {
           super.init(coder: aDecoder)
           self.setup()
       }
    
    
    private func setup() {
        let indicator = FOLoader.shared
        self.addSubview(indicator)
    }
    
}

public class FOLoader: UIView {

    /*
     - Parameter: UIColor
     - Requires: UIColor
     - Description: variable to set the color of activity indicator. By default color is appThemeColor.
     */

    public var color: UIColor = .orange {
        didSet {
            indicator.strokeColor = color.cgColor
        }
    }

    /*
    - Parameter: CGFloat
    - Requires: CGFloat
    - Description: variable to set the line width of activity indicator. By default width is 4.0.
    */

    public var lineWidth: CGFloat = 4.0 {
        didSet {
            indicator.lineWidth = lineWidth
            setNeedsLayout()
        }
    }

    /*
    - Parameter: CGFloat
    - Requires: CGFloat
    - Description: variable to set the Radius of activity indicator. By default Radius is 4.0.
    */

    public var radius : CGFloat = 25 {
        didSet {
            self.frame = CGRect(x: self.center.x - 20, y: self.center.y - 20, width: radius * 2, height: radius * 2)
            setNeedsLayout()
        }
    }

    /*
    - Parameter: N/A
    - Requires: N/A
    - Description: for make sure that only 1 object created for loader at a time.
    */

    public class var shared: FOLoader {
        struct Static {
            static let instance = FOLoader()
        }
        return Static.instance
    }

    private let indicator = CAShapeLayer()
    private let animator = FOActivityIndicatorAnimator()
    private var isAnimating = false
    private let indicatorTag = 17081993


    convenience init() {
        self.init(frame: .zero)
        self.setup()
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }

    /*
    - Parameter: N/A
    - Requires: N/A
    - Description: Default Settings for activity indicator.
    */

    private func setup() {
        indicator.strokeColor = color.cgColor
        indicator.fillColor = nil
        indicator.lineWidth = lineWidth
        indicator.strokeStart = 0.0
        indicator.strokeEnd = 0.0
        indicator.lineCap = .round
        indicator.accessibilityValue = "FNLoader"
        indicator.accessibilityLabel = "FNLoader"
        layer.addSublayer(indicator)
    }

}
extension FOLoader {
    override public var intrinsicContentSize: CGSize {
        return CGSize(width: 40, height: 40)
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        indicator.frame = bounds
        let diameter =  CGFloat.minimum(bounds.size.width, bounds.size.height) - indicator.lineWidth
        let path = UIBezierPath(arcCenter: CGPoint(x: bounds.midX, y: bounds.midY), radius: diameter / 2, startAngle: 0, endAngle: CGFloat(.pi * 2.0), clockwise: true)
        indicator.path = path.cgPath
    }
}

extension FOLoader {

    /*
    - Parameter: N/A
    - Requires: N/A
    - Description: Function to start animating the activity indicator on app window to show user that a task is running in background.
    */

    public func add() {
//        FNU.addLoadIndicator()
        guard !isAnimating else { return }
        animator.addAnimation(to: indicator)
        setupActivityIndicatorViewOnWindow()
        isAnimating = true
    }

    /*
    - Parameter: N/A
    - Requires: N/A
    - Description: Function to stop animating the activity indicator on app window and remove all animations of loader and remove loader View.
    */

    public func remove() {
//        FNU.removeLoadIndicator()
        guard isAnimating else { return }
        animator.removeAnimation(from: indicator)
        UIApplication.shared.windows.first?.viewWithTag(indicatorTag)?.removeFromSuperview()
        isAnimating = false
    }

    /*
    - Parameter: N/A
    - Requires: N/A
    - Description: Function to set Fnloader frame on appWindow with a background view. Background View used here to Avoid any user interaction on screen. A indicator tag has been set on background view so that it can be removed when an activity completed.
    */

    private func setupActivityIndicatorViewOnWindow() {
        if let appWindow = UIApplication.shared.windows.first {
            let backGroundView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
            self.frame = CGRect(x: appWindow.center.x - 20, y: appWindow.center.y - 20, width: radius * 2, height: radius * 2)
            backGroundView.addSubview(self)
            backGroundView.tag = indicatorTag
            appWindow.addSubview(backGroundView)
        }
    }

}

final class FOActivityIndicatorAnimator {

    /*
    - Parameter: N/A
    - Requires: N/A
    - Description: Enum made for frequently used animations of Swift Basic Animations.
    */

    private let animationDuration : TimeInterval = 2.0

    enum Animation: String {
        var key: String {
            return rawValue
        }

        case spring = "material.indicator.spring"
        case rotation = "material.indicator.rotation"
        case rotationZ = "transform.rotation.z"
        case strokeStart = "strokeStart"
        case strokeEnd = "strokeEnd"
    }

    /*
    - Parameter: CALayer
    - Requires: CALayer
    - Description: Function to start or add rotation animation with spring animation.
    */

    public func addAnimation(to layer: CALayer) {
        layer.add(rotationAnimation(), forKey: Animation.rotation.key)
        layer.add(springAnimation(), forKey: Animation.spring.key)
    }

    /*
    - Parameter: CALayer
    - Requires: CALayer
    - Description: Function to remove rotation animation with spring animation.
    */

    public func removeAnimation(from layer: CALayer) {
        layer.removeAnimation(forKey: Animation.spring.key)
    }
}

extension FOActivityIndicatorAnimator {

    /*
    - Parameter: N/A
    - Requires: N/A
    - Description: Performs rotation animation on activity indicator using awesome swift animation CABasicAnimation. To increase the speed of animation decrease duration time using property animation.duration and vice-versa.
    */

    private func rotationAnimation() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: Animation.rotationZ.key)
        animation.fromValue = 0
        animation.toValue = (2.0 * .pi)
        animation.repeatCount = .infinity
        animation.isRemovedOnCompletion = false
        return animation
    }

    /*
    - Parameter: N/A
    - Requires: N/A
    - Description: Performs a group of animations synchronously on activity indicator using awesome swift animation CAAnimationGroup.
    */

    private func springAnimation() -> CAAnimationGroup {
        let animation = CAAnimationGroup()
        animation.duration = self.animationDuration
        animation.isRemovedOnCompletion = false
        animation.animations = [
            rotationAnimation(),
            strokeStartAnimation(),
            strokeEndAnimation(),
            strokeCatchAnimation(),
            strokeFreezeAnimation()
        ]
        animation.repeatCount = .infinity
        return animation
    }

    /*
    - Parameter: N/A
    - Requires: N/A
    - Description: Performs a stroke start animations on activity indicator using awesome swift animation CABasicAnimation.
    */

    private func strokeStartAnimation() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: Animation.strokeStart.key)
        animation.duration = self.animationDuration / 2.0
        animation.fromValue = 0
        animation.toValue = 0.15
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)

        return animation
    }

    /*
    - Parameter: N/A
    - Requires: N/A
    - Description: Performs a stroke end animations on activity indicator using awesome swift animation CABasicAnimation.
    */

    private func strokeEndAnimation() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: Animation.strokeEnd.key)
        animation.duration = self.animationDuration / 2.0
        animation.fromValue = 0
        animation.toValue = 1
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)

        return animation
    }

    /*
    - Parameter: N/A
    - Requires: N/A
    - Description: Performs a stroke start animations with catching the stroke from last position of stroke using awesome swift animation CABasicAnimation.
    */

    private func strokeCatchAnimation() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: Animation.strokeStart.key)
        animation.beginTime = self.animationDuration / 2.0
        animation.duration = self.animationDuration / 2.0
        animation.fromValue = 0.15
        animation.toValue = 1
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)

        return animation
    }

    /*
    - Parameter: N/A
    - Requires: N/A
    - Description: Performs a stroke freeze animation on last position of stroke using awesome swift animation CABasicAnimation.
    */

    private func strokeFreezeAnimation() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: Animation.strokeEnd.key)
        animation.beginTime = self.animationDuration / 2.0
        animation.duration = self.animationDuration / 2.0
        animation.fromValue = 1
        animation.toValue = 1
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        return animation
    }

}
