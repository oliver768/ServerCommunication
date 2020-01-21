//
//  FODataUtils.swift
//  ServerCommunication
//
//  Created by Ravindra Sonkar on 21/01/20.
//  Copyright © 2020 Ravindra Sonkar. All rights reserved.
//

import UIKit

class FODataUtils: NSObject {
    
    class func setButtonCornerRadius(button: UIButton, radius: CGFloat){
        button.layer.cornerRadius = radius
        button.layer.masksToBounds = true
    }
    
    class func setViewCornerRadius(button: UIView, radius: CGFloat){
        button.layer.cornerRadius = radius
        button.layer.masksToBounds = true
    }
    
    class func setImageCornerRadius(image: UIImageView, radius: CGFloat){
        image.layer.cornerRadius = radius
        image.layer.masksToBounds = true
        image.clipsToBounds = true
    }
    
    class func setButtonBorder(button: UIButton, width: CGFloat, color:CGColor){
        button.layer.borderWidth = width
        button.layer.borderColor = color
        button.layer.masksToBounds = true
    }
    
    class func setViewBorder(view: UIView, width: CGFloat, color:CGColor){
        view.layer.borderWidth = width
        view.layer.borderColor = color
        view.layer.masksToBounds = true
    }
    
    class func setTextFieldBorder(textField: UITextField, width: CGFloat, color:CGColor){
        textField.layer.borderWidth = width
        textField.layer.borderColor = color
        textField.layer.masksToBounds = true
    }
    
    class func getCurrentDate(_ format : String? = nil)-> String{
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = format ?? "yyyy-MM-dd"
        let result = formatter.string(from: date)
        return result
    }
    
    class func getCurrentDateTimeForUid()-> String{
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd-hh-mm-ss"
        let result = formatter.string(from: date)
        return result
    }
    
    class func getCurrentDateTime()-> String{
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let result = formatter.string(from: date)
        return result
    }
    
    class func getCurrentDateTimeForSettings()-> Date{
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm aa"
        let result = formatter.string(from: date)
        let date2 = formatter.date(from:result)!
        return date2
    }
    
    class func getDateAsPerTimezone()->String{
        let date = Date()
        let formatter = DateFormatter()
        formatter.timeZone = (TimeZone(abbreviation: "EDT")! as TimeZone)
        formatter.dateFormat = "yyyy-MM-dd"
        let result = formatter.string(from: date)
        return result
    }
    
    class func getCurrentDayName()-> String{
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "eeee"
        let result = formatter.string(from: date)
        let name = result.lowercased()
        return name
    }
    
    public class func stringFromDate(_ rawDate: Date, format:String) -> String? {
        return getDateFormatter(format).string(from: rawDate)
    }
    
    class func getDateFormatter(_ format: String) -> DateFormatter{
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let enUSPOSIXLocale = Locale(identifier: "en_US_POSIX")
        dateFormatter.locale = enUSPOSIXLocale
        dateFormatter.dateFormat = format
        return dateFormatter
    }
    
    public class func dateFromString(_ dateString: String, format:String) -> Date? {
        return getDateFormatter(format).date(from: dateString)
    }
    
    public class func nextMonthStartDate(_ date : Date) -> Date{
        var comp = DateComponents()
        comp.month = 1
        let month = Int(self.stringFromDate(date, format: "MM")!)!
        let MM = (month == 12) ? 01 : month+1
        let year = Int(self.stringFromDate(date, format: "yyyy")!)!
        let yyyy = (month == 12) ? year+1 : year
        let newDate = "\(MM)/01/\(yyyy)"
        return self.dateFromString(newDate, format: "MM/dd/yyyy")!
    }
    
    public class func dateFromUserString(_ rawDate: String!, format:String!, returnFormat:String!) -> String? {
        let dateFormatter = getDateFormatter(format)
        guard let date = dateFormatter.date(from: rawDate) else {
            return rawDate
            //log Exception Here
        }
        dateFormatter.dateFormat = returnFormat
        return dateFormatter.string(from: date)
    }
    
    //MARK:- Return Attributed String

    public static func attributedString(string: String, initialStringColor : UIColor, lastStringColor: UIColor, location: Int, length: Int) -> NSAttributedString{
        let myMutableString = NSMutableAttributedString(string: string, attributes: [:])
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: initialStringColor, range: NSRange(location:0,length:location-1))
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: lastStringColor, range: NSRange(location:location,length:length))
        return myMutableString
    }
    
    public class func isFutureDate (_ date : Date) -> Bool {
        return date.compare(self.dateFromString(self.stringFromDate(FODataUtils.getCurrentDateTimeForSettings(), format: "MM/dd/yyyy")!, format: "MM/dd/yyyy")!) == .orderedDescending
    }
    
    public class func prevMonthStartDate(_ date : Date) -> Date{
        return date.monthStartDate().addingTimeInterval(-24*60*60).monthStartDate()
    }
    
    public class func isPastDate(_ date :Date) ->Bool  {
        return date.compare(FODataUtils.getCurrentDateTimeForSettings()) == ComparisonResult.orderedAscending
    }
    
    class func getStringFromHtmlString(htmlString:String)-> String{
        let content = htmlString // My String
        
        let a = content.replacingOccurrences(of: "<[^>]+>", with: "", options: String.CompareOptions.regularExpression, range: nil)
        
        let b = a.replacingOccurrences(of: "&[^;]+;", with: "", options: String.CompareOptions.regularExpression, range: nil)
        return b
    }
    
   class func convertDateFormater(_ date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss z"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return  dateFormatter.string(from: date!)
        
    }
    
    public class func formattedeNumber(_ rawPhoneNumber : String) ->String{
        return rawPhoneNumber.replacingOccurrences(of: "(\\d{3})(\\d{3})(\\d+)", with: "$1-$2-$3", options: .regularExpression, range: nil)
    }
    
    public class func numberOfDays(date : Date) -> Int {
        return getNumOfDayFromDict(year: Int(self.stringFromDate(date, format: "yyyy")!)!, forMonth: self.stringFromDate(date, format: "MM")!)
    }
        
    public class func getNumOfDayFromDict(year: Int, forMonth month: String) -> Int {
        let dict: NSDictionary = ["01":"31", "02": isLeepYear(year) ? "29" : "28", "03": "31", "04": "30","05": "31","06": "30","07": "31","08": "31","09": "30","10": "31","11": "30","12": "31"]
        return Int(dict.value(forKey: month) as! String)!
    }
    
    public class func isLeepYear(_ year: Int) -> Bool{
        return ((year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0))
    }
    
    static func showAlert(vc: UIViewController,title: String, errorMessage: String) {
        let alert = UIAlertController(title: title, message: errorMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        //    vc.present(alert, animated: true) {
        //        alert.view.transform = CGAffineTransform(rotationAngle: .pi)
        //        alert.view.isHidden = false
        //    }
        ////    present(vc, animated: true, completion: {() -> Void in
        ////        alert.view.transform = CGAffineTransform(rotationAngle: .pi)
        ////        alert.view.hidden = false
        ////    })
        vc.present(alert, animated: true, completion: nil)
    }
    
    static func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    struct ImageStore {
        
        static func delete(imageNamed name: String) {
            guard let imagePath = ImageStore.path(for: name) else {
                return
            }
            
            try? FileManager.default.removeItem(at: imagePath)
        }
        
        static func retrieve(imageNamed name: String) -> UIImage? {
            guard let imagePath = ImageStore.path(for: name) else {
                return nil
            }
            
            return UIImage(contentsOfFile: imagePath.path)
        }
        
        static func store(image: UIImage, name: String) throws {
            
            guard let imageData = image.jpegData(compressionQuality: 1.0) else {
                throw NSError(domain: "com.thecodedself.imagestore", code: 0, userInfo: [NSLocalizedDescriptionKey: "The image could not be created"])
            }
            
            guard let imagePath = ImageStore.path(for: name) else {
                throw NSError(domain: "com.thecodedself.imagestore", code: 0, userInfo: [NSLocalizedDescriptionKey: "The image path could not be retrieved"])
            }
            
            try imageData.write(to: imagePath)
        }
        
        private static func path(for imageName: String, fileExtension: String = "png") -> URL? {
            let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            return directory?.appendingPathComponent("\(imageName).\(fileExtension)")
        }
    }
    
    class func addGradientToImageView(imageView: UIImageView,view: UIView,gradientLayer:CAGradientLayer)->UIImageView{
        
        
        gradientLayer.frame = view.frame
        
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        
       // gradient.locations = [1.0, 0.0]
        gradientLayer.startPoint = CGPoint(x:0, y:0)
        gradientLayer.endPoint = CGPoint(x:0.5, y:1.0)
        view.layer.addSublayer(gradientLayer)
        
        imageView.addSubview(view)
        
        imageView.bringSubviewToFront(view)
        
        return imageView
    }
    
    
    class func curveImageView(imgView: UIImageView) {
        guard let image = imgView.image else {
            return
        }
        
        let size = image.size
        
        imgView.clipsToBounds = true
        imgView.image = image
        
        let curveRadius    = size.width * 0.010 // Adjust curve of the image view here
        let invertedRadius = 1.0 / curveRadius
        
        let rect = CGRect(x: 0,
                          y: -10,
                          width: imgView.bounds.width + size.width * 2 * invertedRadius,
                          height: imgView.bounds.height)
        
        let ellipsePath = UIBezierPath(ovalIn: rect)
        let transform = CGAffineTransform(translationX: -size.width * invertedRadius, y: 0)
        ellipsePath.apply(transform)
        
        let rectanglePath = UIBezierPath(rect: imgView.bounds)
        rectanglePath.apply(CGAffineTransform(translationX: 0, y: -size.height * 0.5))
        
        ellipsePath.append(rectanglePath)
        
        let maskShapeLayer   = CAShapeLayer()
        maskShapeLayer.frame = imgView.bounds
        maskShapeLayer.path  = ellipsePath.cgPath
        maskShapeLayer.backgroundColor = UIColor.clear.cgColor
        imgView.layer.mask = maskShapeLayer
    }
    
    struct ScreenSize
    {
        static let SCREEN_WIDTH = UIScreen.main.bounds.size.width
        static let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
        static let SCREEN_MAX_LENGTH = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
        static let SCREEN_MIN_LENGTH = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    }
    
    struct DeviceType
    {
        static let IS_IPHONE_4_OR_LESS =  UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
        static let IS_IPHONE_5 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
        static let IS_IPHONE_6 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
        static let IS_IPHONE_6P = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    }

    public class func compressImage(_ image : UIImage) -> UIImage {
        var actualHeight = Double(image.size.height)
        var actualWidth = Double(image.size.width)
        let maxHeight = 600.0
        let maxWidth = 800.0
        var imgRatio = actualWidth / actualHeight
        let maxRatio = maxWidth / maxHeight
        let compressionQuality = 0.5//50 percent compression
        if (actualHeight > maxHeight || actualWidth > maxWidth){
            if(imgRatio < maxRatio){
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = maxHeight
            }else if(imgRatio > maxRatio){
                //adjust height according to maxWidth
                imgRatio = Double(maxWidth / actualWidth)
                actualHeight = imgRatio * actualHeight
                actualWidth = maxWidth
            }else{
                actualHeight = maxHeight
                actualWidth = maxWidth
            }
        }
        let rect = CGRect(x: 0.0, y: 0.0, width: actualWidth, height: actualHeight)
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)//[image drawInRect:rect];
        let img = UIGraphicsGetImageFromCurrentImageContext()
        let imageData = img!.jpegData(compressionQuality: CGFloat(compressionQuality))
        UIGraphicsEndImageContext();
        return UIImage(data: imageData!)! //[UIImage imageWithData:imageData];
    }
}
