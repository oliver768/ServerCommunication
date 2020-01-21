//
//  UIVIew.swift
//  TonnijAppNew
//
//  Created by Aditya Sharma on 12/11/19.
//  Copyright © 2019 Mohit Chaudhary. All rights reserved.
//

import UIKit

class FNLabel : UILabel {
    
    var f : CGFloat!
    
    @IBInspectable var font5s : CGFloat {
        get {
            return f
        }
        set(fontSize) {
            if DeviceInfo.isIphone5 {
                font = UIFont(name: "OpenSans", size: fontSize)
            }
        }
    }
        
    override func awakeFromNib() {
        super.awakeFromNib()
        textColor = ColorConstants.textColorGrey.color
//        font = DeviceInfo.typeIsLike == .iphone5 ? UIFont(name: "OpenSans", size: 10.0) : UIFont(name: "OpenSans", size: 13.0)
    }
}

public extension UIView{
    @objc func addToolBar(textView: UITextView){
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = .orange
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(UIView.donePressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        textView.inputAccessoryView = toolBar
    }
    @objc func donePressed(){
        self.endEditing(true)
    }
    
    @objc func addNoRecord(_ msg : String? = nil){
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.backgroundColor = .clear
        label.textColor = UIColor.lightGray
        label.font = UIFont(name: "OpenSans-Regular", size: DeviceInfo.pad ? 20.0 : 16.0)
        label.textAlignment = .center
        label.text = msg ?? "No_Record_Found"
        label.isUserInteractionEnabled = true
        label.tag = 111
        self.addSubview(label)
    }
    
    @objc func removeNoRecord(){
        for addNoRecord in self.subviews {
            if addNoRecord.tag ==  111 {
                addNoRecord.removeFromSuperview()
            }
        }
    }
    
    func removeAllSubviews() {
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }
    
    func addBorders(edges: UIRectEdge, color: UIColor = .green, thickness: CGFloat = 1.0) -> [UIView] {
        
        var borders = [UIView]()
        
        func border() -> UIView {
            let border = UIView(frame: CGRect.zero)
            border.backgroundColor = color
            border.translatesAutoresizingMaskIntoConstraints = false
            return border
        }
        
        if edges.contains(.top) || edges.contains(.all) {
            let top = border()
            addSubview(top)
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[top(==thickness)]",
                                               options: [],
                                               metrics: ["thickness": thickness],
                                               views: ["top": top]))
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[top]-(0)-|",
                                               options: [],
                                               metrics: nil,
                                               views: ["top": top]))
            borders.append(top)
        }
        
        if edges.contains(.left) || edges.contains(.all) {
            let left = border()
            addSubview(left)
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[left(==thickness)]",
                                               options: [],
                                               metrics: ["thickness": thickness],
                                               views: ["left": left]))
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[left]-(0)-|",
                                               options: [],
                                               metrics: nil,
                                               views: ["left": left]))
            borders.append(left)
        }
        
        if edges.contains(.right) || edges.contains(.all) {
            let right = border()
            addSubview(right)
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:[right(==thickness)]-(0)-|",
                                               options: [],
                                               metrics: ["thickness": thickness],
                                               views: ["right": right]))
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[right]-(0)-|",
                                               options: [],
                                               metrics: nil,
                                               views: ["right": right]))
            borders.append(right)
        }
        
        if edges.contains(.bottom) || edges.contains(.all) {
            let bottom = border()
            addSubview(bottom)
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "V:[bottom(==thickness)]-(0)-|",
                                               options: [],
                                               metrics: ["thickness": thickness],
                                               views: ["bottom": bottom]))
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[bottom]-(0)-|",
                                               options: [],
                                               metrics: nil,
                                               views: ["bottom": bottom]))
            borders.append(bottom)
        }
        
        return borders
    }
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        DispatchQueue.main.async {
            let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            self.layer.mask = mask
        }
    }
    
    func roundCorners(_ roundRect: CGRect,  corners: UIRectCorner, radius: CGFloat){
        let path = UIBezierPath(roundedRect: roundRect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func animateView(_ withDuration : Float, blink : Bool){
        if blink {
            let animation = CABasicAnimation(keyPath: "opacity")
            animation.fromValue = NSNumber(value: 1.0)
            animation.toValue = NSNumber(value: 0.0)
            animation.duration = Double(withDuration)
            animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            animation.autoreverses = true
            animation.repeatCount = Float.infinity
            self.layer.add(animation, forKey: "opacity")
        } else{
            self.layer.removeAllAnimations()
        }
    }
    
    func enableDisableView(isEnable : Bool) {
        if isEnable {
            self.alpha = 1
            self.isUserInteractionEnabled = true
        }else {
            self.alpha = 0.5
            self.isUserInteractionEnabled = false
        }
    }
    
    func animateConstraintWithDuration(duration: TimeInterval = 0.5) {
        UIView.animate(withDuration: duration, animations: { [weak self] in
            self?.layoutIfNeeded() ?? ()
        })
    }
    
    func roundCorner() {
        DispatchQueue.main.async {
            self.layer.cornerRadius = self.frame.height/2
        }
    }
    
    func applyZigZagEffect() {
        let width = self.frame.size.width
        let height = self.frame.size.height
        
        let givenFrame = self.frame
        
        let zigZagWidth = CGFloat(7)
        let zigZagHeight = CGFloat(5)
        var yInitial = height-zigZagHeight
        
        let zigZagPath = UIBezierPath(rect: givenFrame)
        zigZagPath.move(to: CGPoint(x:0, y:0))
        
        zigZagPath.addLine(to: CGPoint(x:0, y:yInitial))
        
        var slope = -1
        var x = CGFloat(0)
        var i = 0
        while x < width {
            x = zigZagWidth * CGFloat(i)
            let p = zigZagHeight * CGFloat(slope)
            let y = yInitial + p
            let point = CGPoint(x: x, y: y)
            zigZagPath.addLine(to: point)
            slope = slope*(-1)
            i += 1
        }
        
        zigZagPath.addLine(to: CGPoint(x:width,y: 0))
        yInitial = 0 + zigZagHeight
        x = CGFloat(width)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = zigZagPath.cgPath
        shapeLayer.fillColor = ColorConstants.background.color.cgColor
        self.layer.addSublayer(shapeLayer)
    }
    
    func addShadowEffect(color: UIColor? = .darkGray, type: ShadowType = .Default){
        let height = self.bounds.height
        let width = self.bounds.width
        switch type {
        case .EquallyAllAround:
            self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
            self.layer.shadowRadius = 10
            self.layer.shadowColor = color?.cgColor
            self.layer.shadowOffset = .zero
            self.layer.shadowOpacity = 0.5
        case .ContactShadow:
            let shadowSize: CGFloat = 20
            let contactRect = CGRect(x: -shadowSize, y: height - (shadowSize * 0.4), width: width + shadowSize * 2, height: shadowSize)
            self.layer.shadowPath = UIBezierPath(ovalIn: contactRect).cgPath
            self.layer.shadowRadius = 5
            self.layer.shadowColor = color?.cgColor
            self.layer.shadowOpacity = 0.4
        case .ContactShadow2:
            let shadowSize: CGFloat = 20
            let shadowDistance: CGFloat = 20
            let contactRect = CGRect(x: -shadowSize, y: height - (shadowSize * 0.4) + shadowDistance, width: width + shadowSize * 2, height: shadowSize)
            self.layer.shadowPath = UIBezierPath(ovalIn: contactRect).cgPath
            self.layer.shadowRadius = 5
            self.layer.shadowColor = color?.cgColor
            self.layer.shadowOpacity = 0.4
        case .ContactSahdow3:
            let shadowSize: CGFloat = 10
            let shadowDistance: CGFloat = 40
            let contactRect = CGRect(x: shadowSize, y: height - (shadowSize * 0.4) + shadowDistance, width: width - shadowSize * 2, height: shadowSize)
            self.layer.shadowPath = UIBezierPath(ovalIn: contactRect).cgPath
            self.layer.shadowRadius = 5
            self.layer.shadowColor = color?.cgColor
            self.layer.shadowOpacity = 0.4
        case .DepthShadow:
            let shadowRadius: CGFloat = 5
            
            // how wide and high the shadow should be, where 1.0 is identical to the view
            let shadowWidth: CGFloat = 1.25
            let shadowHeight: CGFloat = 0.5
            
            let shadowPath = UIBezierPath()
            shadowPath.move(to: CGPoint(x: shadowRadius / 2, y: height - shadowRadius / 2))
            shadowPath.addLine(to: CGPoint(x: width - shadowRadius / 2, y: height - shadowRadius / 2))
            shadowPath.addLine(to: CGPoint(x: width * shadowWidth, y: height + (height * shadowHeight)))
            shadowPath.addLine(to: CGPoint(x: width * -(shadowWidth - 1), y: height + (height * shadowHeight)))
            self.layer.shadowPath = shadowPath.cgPath
            self.layer.shadowRadius = shadowRadius
            self.layer.shadowOffset = .zero
            self.layer.shadowColor = color?.cgColor
            self.layer.shadowOpacity = 0.2
        case .DepthSahdowTilted:
            let shadowWidth: CGFloat = 1.2
            let shadowHeight: CGFloat = 0.5
            let shadowOffsetX: CGFloat = -50
            let shadowRadius: CGFloat = 5
            
            let shadowPath = UIBezierPath()
            shadowPath.move(to: CGPoint(x: shadowRadius / 2, y: height - shadowRadius / 2))
            shadowPath.addLine(to: CGPoint(x: width, y: height - shadowRadius / 2))
            shadowPath.addLine(to: CGPoint(x: width * shadowWidth + shadowOffsetX, y: height + (height * shadowHeight)))
            shadowPath.addLine(to: CGPoint(x: width * -(shadowWidth - 1) + shadowOffsetX, y: height + (height * shadowHeight)))
            self.layer.shadowPath = shadowPath.cgPath
            self.layer.shadowColor = color?.cgColor
            self.layer.shadowRadius = shadowRadius
            self.layer.shadowOffset = .zero
            self.layer.shadowOpacity = 0.2
        case .FlatLongShadow:
            self.layer.shadowRadius = 0
            self.layer.shadowOffset = .zero
            self.layer.shadowOpacity = 0.2
            
            // how far the bottom of the shadow should be offset
            let shadowOffsetX: CGFloat = 2000
            let shadowPath = UIBezierPath()
            shadowPath.move(to: CGPoint(x: 0, y: height))
            shadowPath.addLine(to: CGPoint(x: width, y: height))
            
            // make the bottom of the shadow finish a long way away, and pushed by our X offset
            shadowPath.addLine(to: CGPoint(x: width + shadowOffsetX, y: 2000))
            shadowPath.addLine(to: CGPoint(x: shadowOffsetX, y: 2000))
            self.layer.shadowPath = shadowPath.cgPath
            self.layer.shadowColor = color?.cgColor
            
            self.backgroundColor = UIColor(red: 230 / 255, green: 126 / 255, blue: 34 / 255, alpha: 1.0)
        case .FlatLongShadowTilted:
            let shadowOffsetX: CGFloat = 2000
            let shadowPath = UIBezierPath()
            self.layer.shadowColor = color?.cgColor
            shadowPath.move(to: CGPoint(x: 0, y: height))
            shadowPath.addLine(to: CGPoint(x: width, y: 0))
            shadowPath.addLine(to: CGPoint(x: width + shadowOffsetX, y: 2000))
            shadowPath.addLine(to: CGPoint(x: shadowOffsetX, y: 2000))
            self.layer.shadowPath = shadowPath.cgPath
        case .CurvedShadow:
            let shadowRadius: CGFloat = 5
            self.layer.shadowRadius = shadowRadius
            self.layer.shadowOffset = CGSize(width: 0, height: 10)
            self.layer.shadowOpacity = 0.5
            self.layer.shadowColor = color?.cgColor
            // how strong to make the curling effect
            let curveAmount: CGFloat = 20
            let shadowPath = UIBezierPath()
            
            // the top left and right edges match our view, indented by the shadow radius
            shadowPath.move(to: CGPoint(x: shadowRadius, y: 0))
            shadowPath.addLine(to: CGPoint(x: width - shadowRadius, y: 0))
            
            // the bottom-right edge of our shadow should overshoot by the size of our curve
            shadowPath.addLine(to: CGPoint(x: width - shadowRadius, y: height + curveAmount))
            
            // the bottom-left edge also overshoots by the size of our curve, but is added with a curve back up towards the view
            shadowPath.addCurve(to: CGPoint(x: shadowRadius, y: height + curveAmount), controlPoint1: CGPoint(x: width, y: height - shadowRadius), controlPoint2: CGPoint(x: 0, y: height - shadowRadius))
            self.layer.shadowPath = shadowPath.cgPath
        case .DoubleStrokes:
            let shadowSize: CGFloat = 20
            let shadowPath = UIBezierPath(rect: CGRect(x: -2, y: -2, width: width + 4, height: height + 4))
            self.layer.shadowPath = shadowPath.cgPath
            self.layer.shadowColor = color?.cgColor
            
            self.layer.shadowOffset = .zero
            self.layer.shadowRadius = 0
            self.layer.shadowOpacity = 1
            
            self.layer.borderColor = UIColor.white.cgColor
            self.layer.borderWidth = shadowSize
        case .CardView:
            self.layer.shadowRadius = 5
            self.layer.shadowOffset = .zero
            self.layer.shadowColor = color?.cgColor
            self.layer.shadowOpacity = 1
        case .Default:
            self.layer.shadowColor = color?.cgColor
            self.layer.shadowOpacity = 1
        }
        
        
    }
    
    
}

public enum ShadowType: Int{
    case EquallyAllAround
    case ContactShadow
    case ContactShadow2
    case ContactSahdow3
    case DepthShadow
    case DepthSahdowTilted
    case FlatLongShadow
    case FlatLongShadowTilted
    case CurvedShadow
    case DoubleStrokes
    case Default
    case CardView
}
