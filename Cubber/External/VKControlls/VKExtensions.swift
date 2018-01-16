//
//  Extensions.swift
//  Cubber
//
//  Created by Vyas Kishan on 16/07/16.
//  Copyright © 2016 DNKTechnologies. All rights reserved.
//

import Foundation
import UIKit
import ImageIO
import ModelIO
import FirebaseAnalytics
import Firebase
import Google

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


extension UIViewController {
    
    func sendScreenView(name:String) {
        
        TAGManager.instance().dataLayer.push(["event":"openScreen" , "screenName":"\(name)"])
        let tracker = GAI.sharedInstance().defaultTracker
        tracker?.set(kGAIScreenName, value: name)
        tracker?.send(GAIDictionaryBuilder.createScreenView().build() as [NSObject : AnyObject])
    }
    
    func trackEvent(category: String, action: String, label: String, value: NSNumber?) {
        
       // let tracker = GAI.sharedInstance().defaultTracker
       // tracker!.send(GAIDictionaryBuilder.createEvent(withCategory: category, action: action, label: label, value: nil).build() as [NSObject : AnyObject])
        
    }
    
    func createEcxeption(Description:String){
        
     /*   let tracker = GAI.sharedInstance().defaultTracker
        tracker!.send(_DictionaryBuilder.createException(withDescription: Description, withFatal: nil) .build() as [NSObject : AnyObject]) */
    }
    
    func FIRLogEvent(name:String , parameters:[String:NSObject]){
        
        var params = parameters
        params.removeValue(forKey: FIR_SELECT_CONTENT)
        params[AnalyticsEventSelectContent] = parameters[FIR_SELECT_CONTENT]
        Analytics.logEvent(name, parameters: params)
        self.sendScreenView(name: name)
    }
    
    func SetScreenName(name:String ,stclass:String) {
        
       // Analytics.setScreenName(name, screenClass: stclass)
    }
    
    func setUserProperty(propertyName:String , PropertyValue:String) {
        Analytics.setUserProperty(PropertyValue, forName: propertyName)
    }

}
extension UISegmentedControl {
    func setCustomSegment() {
        //SET SEGMENT CONTROLL STYLE
        UILabel.appearance(whenContainedInInstancesOf: [UISegmentedControl.self]).numberOfLines = 0
        tintColor = COLOUR_ORANGE
        
        self.titleForSegment(at: 0)
        let attributes: [String: Any] = [NSFontAttributeName:UIFont.systemFont(ofSize: 13)]
        self.setTitleTextAttributes(attributes, for: .normal)
    }
}


extension UITextField {
        
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.autocapitalizationType = UITextAutocapitalizationType.none;
        self.autocorrectionType = UITextAutocorrectionType.no;
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftViewMode = UITextFieldViewMode.always;
        self.leftView = view;
    
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(UITextField.viewClick))
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true
        view.isMultipleTouchEnabled = true
        
        if self.keyboardType == UIKeyboardType.numberPad {
            let toolbar = UIToolbar.init()
            toolbar.sizeToFit()
            let barBtnDone = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(btnBarDoneAction))
            toolbar.items = [barBtnDone]
            self.inputAccessoryView = toolbar
        }
    }
    
    func isOtherLanguageMode(_ string:String) -> Bool {
        if string.isEmpty{ return false }
        if self.textInputMode?.primaryLanguage != nil &&  self.textInputMode!.primaryLanguage!.contains("en") { return false }
        return true
    }
    
    func viewClick() {
        self.becomeFirstResponder();
    }
    
    func btnBarDoneAction() { self.resignFirstResponder() }
    
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}

extension String {
    
    mutating func replace(_ string: String, withString: String) -> String {
        return self.replacingOccurrences(of: string, with: withString)
    }
    
    mutating func replaceWhiteSpace(_ withString: String) -> String {
        let components = self.components(separatedBy: CharacterSet.whitespaces)
        let filtered = components.filter({!$0.isEmpty})
        return filtered.joined(separator: "")
    }
    
    func textWidth(_ textHeight: CGFloat, textFont: UIFont) -> CGFloat {
        let textRect: CGRect = self.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: textHeight), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: textFont], context: nil)
        let textSize: CGSize = textRect.size;
        return textSize.width;
    }
    
    func textHeight(_ textWidth: CGFloat, textFont: UIFont) -> CGFloat {
        let textRect: CGRect = self.boundingRect(with: CGSize(width: textWidth, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: textFont], context: nil)
        let textSize: CGSize = textRect.size;
        return textSize.height;
    }
    
    func textSize(_ textFont: UIFont) -> CGSize {
        let textRect: CGRect = self.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: textFont], context: nil)
        return textRect.size;
    }
    
    func trim() -> String { return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) }
    
    mutating func extractPhoneNo() -> String {
        self = self.trim()
        self = self.replaceWhiteSpace("")
        self = self.replace("(", withString: "")
        self = self.replace(")", withString: "")
        self = self.replace("+91", withString: "")
        self = self.replace("+", withString: "")
        self = self.hasPrefix("0") ? String(self.characters.dropFirst()) : self //self.remove(at: self.startIndex)
        self = self.replace("-", withString: "")
        return self
    }
    
    func convertToUrl() -> URL {
        let data:Data = self.data(using: String.Encoding.utf8)!
        var resultStr: String = String(data: data, encoding: String.Encoding.nonLossyASCII)!
        
        if !(resultStr.hasPrefix("itms://")) && !(resultStr.hasPrefix("file://")) && !(resultStr.hasPrefix("http://")) && !(resultStr.hasPrefix("https://")) { resultStr = "http://" + resultStr }
        
        resultStr = resultStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        return URL(string: resultStr)!
    }
    
    mutating func encode() -> String {
        let customAllowedSet =  CharacterSet(charactersIn:" !+=\"#%/<>?@\\^`{|}$&()*-").inverted
        self = self.addingPercentEncoding(withAllowedCharacters: customAllowedSet)!
        return self
    }
    
    func isNumeric() -> Bool {
        var holder: Float = 0.00
        let scan: Scanner = Scanner(string: self)
        let RET: Bool = scan.scanFloat(&holder) && scan.isAtEnd
        if self == "." { return false }
        return RET
    }
    
    func isContainString(_ subString: String) -> Bool {
        let range = self.range(of: subString, options: NSString.CompareOptions.caseInsensitive, range: self.range(of: self))
        return range == nil ? false : true
    }
    
    func hexadecimal() -> Data? {
        var data = Data(capacity: characters.count / 2)
        
        let regex = try! NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
        regex.enumerateMatches(in: self, options: [], range: NSMakeRange(0, characters.count)) { match, flags, stop in
            let byteString = (self as NSString).substring(with: match!.range)
            var num = UInt8(byteString, radix: 16)!
            data.append(&num, count: 1)
        }
        
        guard data.count > 0 else {
            return nil
        }
        
        return data
    }
    
    func removeSpecialCharsFromString(text: String) -> String {
        let okayChars : Set<Character> =
            Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890")
        return String(text.filter {okayChars.contains($0) })
    }
    
    func convertToDictionary2() -> typeAliasDictionary {
        let jsonData: Data = self.data(using: String.Encoding.utf8)!
        do {
            let dict: typeAliasDictionary = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions()) as! typeAliasDictionary
            return dict
        } catch let error as NSError { print(error) }
        
        return typeAliasDictionary()
    }
    
    func toHexBytes() -> [UInt8] {
    
        var data = [UInt8]()
        let utfff = Array<UInt8>(self.utf8)
         let skip0x = self.hasPrefix("0x") ? 2 : 0
        for idx in stride(from: utfff.startIndex.advanced(by: skip0x), to: utfff.endIndex, by: utfff.startIndex.advanced(by: 2)) {
            let byteHex = "\(UnicodeScalar(utfff[idx]))\(UnicodeScalar(utfff[idx.advanced(by: 1)]))"
            if let byte = UInt8(byteHex, radix: 16) {
            data.append(byte)
            }
        
        }
        return data
    }
   
    func removeSpecialCharsFromString() -> String {
        let okayChars : Set<Character> =
            Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890+-*=(),.:!_{}\\/\"@#$%^&[]")
        return String(self.filter {okayChars.contains($0) })
    }
    
    var isNumber : Bool {
        get{
            return !self.isEmpty && self.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
        }
    }
    
    var isAlphanumeric: Bool {
        get{
            return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
        }
    }
    
    func hexStringToUIColor() -> UIColor {
        var cString:String = self.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    var htmlAttributedString: NSAttributedString? {
        //'-apple-system', 'HelveticaNeue'
         let modifiedFont = NSString(format:"<span style=\"font-family: '-apple-system', 'HelveticaNeue'; font-size: 15 \">%@</span>" as NSString, self) as String
        do {
            return try NSAttributedString(data: modifiedFont.data(using: .utf8)!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch let error {
            print(error.localizedDescription)
        }
        return nil
    }
    
     func setThousandSeperator() -> String {
          return  self.setThousandSeperator(decimal: 0)
    }
    
     func setThousandSeperator(decimal:Int) -> String {
        let numberFormatter = NumberFormatter.init()
        numberFormatter.groupingSeparator = ","
        numberFormatter.groupingSize = 3
        numberFormatter.locale = Locale.init(identifier: "en_IN")
        numberFormatter.currencyCode = "INR"
        numberFormatter.decimalSeparator = "."
        numberFormatter.maximumFractionDigits = decimal
        numberFormatter.numberStyle = NumberFormatter.Style.currency
        numberFormatter.currencySymbol = "\(RUPEES_SYMBOL)"
       // numberFormatter.usesGroupingSeparator = true
        return numberFormatter.string(from: NSNumber.init(value: Double(self)! as Double))!
        
    }

}

extension Date {
    var age: Int {
        return Calendar.current.dateComponents([.year], from: self, to: Date()).year!
    }
}

extension Calendar {
    
    func dayOfWeek(_ date: Date) -> Int {
        var dayOfWeek = self.component(.weekday, from: date) + 1 - self.firstWeekday
        
        if dayOfWeek <= 0 {
            dayOfWeek += 7
        }
        
        return dayOfWeek
    }
    
    func startOfWeek(_ date: Date) -> Date {
        return self.date(byAdding: DateComponents(day: -self.dayOfWeek(date) + 1), to: date)!
    }
    
    func endOfWeek(_ date: Date) -> Date {
        return self.date(byAdding: DateComponents(day: 6), to: self.startOfWeek(date))!
    }
    
    func startOfMonth(_ date: Date) -> Date {
        return self.date(from: self.dateComponents([.year, .month], from: date))!
    }
    
    func endOfMonth(_ date: Date) -> Date {
        return self.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth(date))!
    }
    
    func startOfQuarter(_ date: Date) -> Date {
        let quarter = (self.component(.month, from: date) - 1) / 3 + 1
        return self.date(from: DateComponents(year: self.component(.year, from: date), month: (quarter - 1) * 3 + 1))!
    }
    
    func endOfQuarter(_ date: Date) -> Date {
        return self.date(byAdding: DateComponents(month: 3, day: -1), to: self.startOfQuarter(date))!
    }
    
    func startOfYear(_ date: Date) -> Date {
        return self.date(from: self.dateComponents([.year], from: date))!
    }
    
    func endOfYear(_ date: Date) -> Date {
        return self.date(from: DateComponents(year: self.component(.year, from: date), month: 12, day: 31))!
    }
}

extension Dictionary {
    func convertToJSonString() -> String {
        do {
            let dataJSon = try JSONSerialization.data(withJSONObject: self as AnyObject, options: [])//JSONSerialization.WritingOptions.prettyPrinted
             let st: String = String.init(data: dataJSon, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
            //let st: NSString = NSString.init(data: dataJSon, encoding: String.Encoding.utf8.rawValue)!
            return (st as String).trim()
        } catch let error as NSError { print(error) }
        return ""
    }
    
    func isKeyNull(_ stKey: String) -> Bool {
        let dict: typeAliasDictionary = (self as AnyObject) as! typeAliasDictionary
        if let val = dict[stKey] { return val is NSNull ? true : false }
        return true
    }
}
    
extension NSRange {
    func toRange(string: String) -> Range<String.Index> {
        let startIndex = string.characters.index(string.startIndex, offsetBy: location)
        let endIndex = string.characters.index(startIndex, offsetBy: length)
        return startIndex..<endIndex
    }
}

extension UIImageView {

    func setStaticImage(imageName:String) {
        
        let imageData = try? Data(contentsOf: Bundle.main.url(forResource: imageName, withExtension: "gif")!)
        guard let source = CGImageSourceCreateWithData(imageData as! CFData, nil) else {
            print("SwiftGif: Source for the image does not exist")
            return
        }
        let count = CGImageSourceGetCount(source)
        var images = [UIImage]()
        
        for i in 0..<count {
            // Add image
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(UIImage(cgImage: image))
            }
            
        }
        self.image = images.first
        self.animationImages = images
        self.animationDuration = Double(images.count) * 0.05
         self.startAnimating()
    }
    
}

 extension UIView {
    
    func addDashedLine(color: UIColor) {
        
        let  borderLayer = CAShapeLayer()
        borderLayer.name  = "borderLayer"
        let frameSize = self.frame.size
        
        let shapeRect = CGRect(x: 0, y: 0, width: 0, height: frameSize.height)
        
        borderLayer.bounds=shapeRect
        borderLayer.position =  CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = color.cgColor
        borderLayer.lineWidth = 1
        borderLayer.lineJoin=kCALineJoinRound
        borderLayer.lineDashPattern = [4,4]
        
        let path = UIBezierPath.init(roundedRect: shapeRect, cornerRadius: 0)
        
        borderLayer.path = path.cgPath
        
        self.layer.addSublayer(borderLayer)
    }
    
    func addDashedHorizontalLine(color: UIColor) {
        
        let  borderLayer = CAShapeLayer()
        borderLayer.name  = "borderLayer"
        let frameSize = self.frame.size
        
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: 0)
        
        borderLayer.bounds=shapeRect
        borderLayer.position =  CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = color.cgColor
        borderLayer.lineWidth = 1
        borderLayer.lineJoin=kCALineJoinRound
        borderLayer.lineDashPattern = [4,4]
        
        let path = UIBezierPath.init(roundedRect: shapeRect, cornerRadius: 0)
        
        borderLayer.path = path.cgPath
        
        self.layer.addSublayer(borderLayer)
    }
    
    
   

    
    @IBInspectable var borderColor:UIColor? {
        set {
            layer.borderColor = newValue!.cgColor
        }
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor:color)
            }
            else {
                return nil
            }
        }
    }
    @IBInspectable var borderWidth:CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    @IBInspectable var cornerRadius:CGFloat {
        set {
            layer.cornerRadius = newValue
            clipsToBounds = newValue > 0
        }
        get {
            return layer.cornerRadius
        }
    }
    
    func setHighlight() {
        self.setViewBorder(COLOUR_GREEN, borderWidth: 2, isShadow: false, cornerRadius: 0, backColor: UIColor.clear)
    }
    
    func unSetHighlight() {
        self.setViewBorder(COLOUR_TEXTFIELD_BORDER, borderWidth: 1, isShadow: false, cornerRadius: 0, backColor: UIColor.clear)
    }
    
    func setBottomBorder(_ borderColor: UIColor, borderWidth: CGFloat) {
        let tagLayer: String = "100000"
        if self.layer.sublayers?.count > 1 && self.layer.sublayers?.last?.accessibilityLabel == tagLayer {
            self.layer.sublayers?.last?.removeFromSuperlayer()
        }
        let border: CALayer = CALayer()
        border.backgroundColor = borderColor.cgColor;
        border.accessibilityLabel = tagLayer;
        border.frame = CGRect(x: 0, y: self.frame.height - borderWidth, width: self.frame.width, height: borderWidth);
        self.layer.addSublayer(border)
        self.clipsToBounds = true
    }
    
    func setTopBorder(_ borderColor: UIColor, borderWidth: CGFloat) {
        let tagLayer: String = "100000"
        if self.layer.sublayers?.count > 1 && self.layer.sublayers?.last?.accessibilityLabel == tagLayer {
            self.layer.sublayers?.last?.removeFromSuperlayer()
        }
        let border: CALayer = CALayer()
        border.backgroundColor = borderColor.cgColor;
        border.accessibilityLabel = tagLayer;
        border.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: borderWidth);
        self.layer.addSublayer(border)
        self.clipsToBounds = true
    }

    
    func setViewBorder(_ borderColor: UIColor, borderWidth: CGFloat, isShadow: Bool, cornerRadius: CGFloat, backColor: UIColor) {
        self.backgroundColor = backColor;
        self.layer.borderWidth = borderWidth;
        self.layer.borderColor = borderColor.cgColor;
        self.layer.cornerRadius = cornerRadius;
        if isShadow { self.setShadowDrop(self) }
    }
    
    func setShadowDrop(_ view: UIView) {
        //http://stackoverflow.com/questions/4754392/uiview-with-rounded-corners-and-drop-shadow
        let layer: CALayer = view.layer
        layer.masksToBounds = false
        layer.shadowOffset = CGSize(width: 1, height: 1);
        layer.shadowColor = UIColor.black.cgColor;
        layer.shadowRadius = 4.0;
        layer.shadowOpacity = 0.2;
    }
    
    func round(corners: UIRectCorner, radius: CGFloat) -> Void {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func addDashedBorder (color:UIColor) {
        
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineJoin = kCALineJoinRound
        shapeLayer.lineDashPattern = [6,3]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 3).cgPath
        
        self.layer.addSublayer(shapeLayer)
    }
    
    func takeSnapshot(frame:CGRect) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(CGSize.init(width: UIScreen.main.bounds.width, height: frame.height), false, UIScreen.main.scale)
        self.drawHierarchy(in: CGRect.init(x: -frame.origin.x, y: -frame.origin.y, width: frame.width, height: frame.height), afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        //UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
        return image!
    }
    
    func applyGradient(colours: [UIColor]) -> Void {
        self.applyGradient(colours: colours, locations: nil, frame: self.bounds)
    }
    
    func applyGradient(colours: [UIColor], locations: [NSNumber]? , frame:CGRect) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = frame
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
    }
}

extension CALayer {
    func setBorderUIColor(_ color: UIColor) {
        self.borderColor = color.cgColor
    }
    
    func borderUIColor(_ color: UIColor) -> UIColor {
        return UIColor.init(cgColor: self.borderColor!)
    }
    
    func addGradientColor(colors:[UIColor]) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame =  CGRect(origin: .zero, size: self.bounds.size)
        gradientLayer.startPoint = CGPoint(x:0.0, y:0.5)
        gradientLayer.endPoint = CGPoint(x:1.0, y:0.5)
        gradientLayer.colors = colors.map({$0.cgColor})
        self.addSublayer(gradientLayer)
    }

}

extension UIButton {
    func setHyperLink() {
        let text: String = self.currentTitle!;
        let dictAttribute: typeAliasDictionary = [NSUnderlineStyleAttributeName:NSUnderlineStyle.styleSingle.rawValue as AnyObject,
                    NSForegroundColorAttributeName:(self.titleLabel?.textColor)!]
        self.titleLabel?.attributedText = NSAttributedString(string: text, attributes: dictAttribute)
    }
    
    func setMultiLineText() {
        self.titleLabel?.numberOfLines = 0
        self.titleLabel?.textAlignment = NSTextAlignment.center
    }
}

extension UISegmentedControl {
    func setCubberLayout() {
//        if #available(iOS 9.0, *) {
//            UILabel.appearanceWhenContainedInInstancesOfClasses([UISegmentedControl.self]).numberOfLines = 0
//        } else {
//            // Fallback on earlier versions
//        }
        self.tintColor = COLOUR_ORANGE;
        self.subviews[0].tintColor = COLOUR_ORANGE
        self.titleForSegment(at: 0)
    }
}

extension NSMutableAttributedString{
    func setColorForText(_ textToFind: String, with color: UIColor) {
        let range = self.mutableString.range(of: textToFind, options: .caseInsensitive)
        if range.location != NSNotFound {
            addAttribute(NSForegroundColorAttributeName, value: color, range: range)
        }
    }
}

extension Array {
    func convertToJSonString() -> String {
        do {
            let dataJSon = try JSONSerialization.data(withJSONObject: self as AnyObject, options: JSONSerialization.WritingOptions.prettyPrinted)
            //let st: NSString = NSString.init(data: dataJSon, encoding: String.Encoding.utf8.rawValue)!
            let st: String = String(data: dataJSon, encoding: .utf8)!
            return st
        } catch let error as NSError { print(error) }
        return ""
        
        
    }
    
    func getArrayFromArrayOfDictionary(key: String, valueString: String, valueInt: String) -> [typeAliasDictionary] {
        if !valueString.isEmpty {
            let predicate = NSPredicate(format: "%K LIKE[cd] %@", key, valueString)
            return (self as NSArray).filtered(using: predicate) as! [typeAliasDictionary]
        }
        else if !valueInt.isEmpty {
            let predicate = NSPredicate(format: "%K = %d", key, Int(valueInt)!)
            return (self as NSArray).filtered(using: predicate) as! [typeAliasDictionary]
        }
        
        return [typeAliasDictionary]()
    }
    
    func getArrayFromArrayOfDictionary(key: String, notValueString: [String], notValueInt: [String]) -> [typeAliasDictionary] {
        if !notValueString.isEmpty {
            var arrCondition = [String]()
            for value in notValueString { arrCondition.append("(NOT \(key) LIKE[cd] \"\(value)\")") }
            let stCondition: String = arrCondition.joined(separator: " AND ")
            
            let predicate = NSPredicate(format: stCondition)
            return (self as NSArray).filtered(using: predicate) as! [typeAliasDictionary]
        }
        else if !notValueInt.isEmpty {
            //            let predicate = NSPredicate(format: "%K != %d", key, Int(notValueInt)!)
            //            return (self as NSArray).filtered(using: predicate) as! [typeAliasDictionary]
        }
        
        return [typeAliasDictionary]()
    }
    
    func getArrayFromArrayOfDictionary2(key: String, valueString: String, valueInt: String) -> [typeAliasStringDictionary] {
        if !valueString.isEmpty {
            let predicate = NSPredicate(format: "%K LIKE[cd] %@", key, valueString)
            return (self as NSArray).filtered(using: predicate) as! [typeAliasStringDictionary]
        }
        else if !valueInt.isEmpty {
            let predicate = NSPredicate(format: "%K = %d", key, Int(valueInt)!)
            return (self as NSArray).filtered(using: predicate) as! [typeAliasStringDictionary]
        }
        
        return [typeAliasStringDictionary]()
    }
    
    func getArrayFromArrayOfString(valueString: String, valueInt: String) -> [String] {
        if !valueString.isEmpty {
            let predicate = NSPredicate(format: "SELF LIKE[cd] %@", valueString)
            return (self as NSArray).filtered(using: predicate) as! [String]
        }
        else if !valueInt.isEmpty {
            let predicate = NSPredicate(format: "SELF = %d", Int(valueInt)!)
            return (self as NSArray).filtered(using: predicate) as! [String]
        }
        
        return [String]()
    }
}

extension URL {
    func getDataFromQueryString() -> typeAliasStringDictionary {
        let urlComponents: URLComponents = URLComponents(url: self, resolvingAgainstBaseURL: false)!
        let arrQueryItems: Array<URLQueryItem> = urlComponents.queryItems!
        var dictParams = typeAliasStringDictionary()
        for item:URLQueryItem in arrQueryItems { dictParams[item.name] = item.value }
        return dictParams
    }
}

public enum ImageFormat {
    case PNG
    case JPEG(CGFloat)
}

extension UIImage {
    
    public func base64(format: ImageFormat) -> String {
        var imageData: NSData
        switch format {
        case .PNG: imageData = UIImagePNGRepresentation(self)! as NSData
        case .JPEG(let compression): imageData = UIImageJPEGRepresentation(self, compression)! as NSData
        }
        return imageData.base64EncodedString(options: [])
    }
    
  
}

extension UILabel {
    
    func addCharacterSpacing() {
        if let labelText = text, labelText.count > 0 {
            let attributedString = NSMutableAttributedString(string: labelText)
            attributedString.addAttribute(NSKernAttributeName, value: CGFloat(20), range: NSRange(location: 0, length: attributedString.length - 1))
           // attributedString.addAttribute(NSAttributedStringKey.kern, value: 1.15, range: NSRange(location: 0, length: attributedString.length - 1))
            self.attributedText = attributedString
        }
    }
    
    private struct AssociatedKeys {
        static var padding = UIEdgeInsets()
    }
    
    public var padding: UIEdgeInsets? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.padding) as? UIEdgeInsets
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys.padding, newValue as UIEdgeInsets!, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    override open func draw(_ rect: CGRect) {
        if let insets = padding {
            self.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
        } else {
            self.drawText(in: rect)
        }
    }
    
    override open var intrinsicContentSize: CGSize {
        guard let text = self.text else { return super.intrinsicContentSize }
        
        var contentSize = super.intrinsicContentSize
        var textWidth: CGFloat = frame.size.width
        var insetsHeight: CGFloat = 0.0
        
        if let insets = padding {
            textWidth -= insets.left + insets.right
            insetsHeight += insets.top + insets.bottom
        }
        
        let newSize = text.boundingRect(with: CGSize(width: textWidth, height: CGFloat.greatestFiniteMagnitude),
                                        options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                        attributes: [NSFontAttributeName: self.font], context: nil)
        
        contentSize.height = ceil(newSize.size.height) + insetsHeight
        
        return contentSize
    }
}

public extension UIDevice {
    
    public var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8 , value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPhone10,1", "iPhone10,4":                 return "iPhone 8"
        case "iPhone10,2", "iPhone10,5":                 return "iPhone 8 Plus"
        case "iPhone10,3", "iPhone10,6":                 return "iPhone X"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,3", "iPad6,4", "iPad6,7", "iPad6,8":return "iPad Pro"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
}
