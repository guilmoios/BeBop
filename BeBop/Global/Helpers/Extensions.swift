//
//  Extensions.swift
//  BeBop
//
//  Created by Guilherme Mogames on 10/4/17.
//  Copyright © 2017 Mogames. All rights reserved.
//

import UIKit

private var __maxLengths: [UITextField: Int] = [:]

// MARK: - UIImage
extension UIImage {
    
    static func filled(with color: UIColor) -> UIImage {
        let pixelScale = UIScreen.main.scale
        let pixelSize = 1 / pixelScale
        let fillSize = CGSize(width: pixelSize, height: pixelSize)
        let fillRect = CGRect(origin: CGPoint.zero, size: fillSize)
        
        UIGraphicsBeginImageContextWithOptions(fillRect.size, false, pixelScale)
        
        let graphicsContext = UIGraphicsGetCurrentContext()
        graphicsContext!.setFillColor(color.cgColor)
        graphicsContext!.fill(fillRect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
}

// MARK: - UIView
extension UIView {
    
    var bottom: CGFloat {
        return self.y + self.height
    }
    
    var right: CGFloat {
        return self.x + self.width
    }
    
    var height: CGFloat {
        get {
            return self.frame.size.height
        }
        
        set {
            self.setPartialFrame(frame: CGRect(x: CGFloat.nan, y: CGFloat.nan, width: CGFloat.nan, height: newValue))
        }
    }
    
    var width: CGFloat {
        
        get {
            return self.frame.size.width
        }
        
        set {
            self.setPartialFrame(frame: CGRect(x: CGFloat.nan, y: CGFloat.nan, width: newValue, height: CGFloat.nan))
        }
    }
    
    var x: CGFloat {
        get {
            return self.frame.origin.x
        }
        
        set {
            self.setPartialFrame(frame: CGRect(x: newValue, y: CGFloat.nan, width: CGFloat.nan, height: CGFloat.nan))
        }
    }
    
    var y: CGFloat {
        get {
            return self.frame.origin.y
        }
        
        set {
            self.setPartialFrame(frame: CGRect(x: CGFloat.nan, y: newValue, width: CGFloat.nan, height: CGFloat.nan))
        }
    }
    
    var size: CGSize {
        get {
            return self.frame.size
        }
        
        set {
            self.setPartialFrame(frame: CGRect(x: CGFloat.nan, y: CGFloat.nan, width: newValue.width, height: newValue.height))
        }
    }
    
    var origin: CGPoint {
        get {
            return self.frame.origin
        }
        
        set {
            self.setPartialFrame(frame: CGRect(x: newValue.x, y: newValue.y, width: CGFloat.nan, height: CGFloat.nan))
        }
    }
    
    func setPartialFrame(frame: CGRect) {
        
        var partialFrame = frame
        if partialFrame.origin.x.isNaN {
            partialFrame.origin.x = self.x
        }
        if partialFrame.origin.y.isNaN {
            partialFrame.origin.y = self.y
        }
        if partialFrame.size.width.isNaN {
            partialFrame.size.width = self.width
        }
        if partialFrame.size.height.isNaN {
            partialFrame.size.height = self.height
        }
        
        self.frame = partialFrame
    }
    
    var rounded: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        
        set {
            self.layer.cornerRadius = newValue
        }
    }
}

// MARK: String
extension String {
    
    var length: Int {
        return characters.count
    }
    
    var chomp : String {
        mutating get {
            return String(self.characters.dropFirst())
        }
    }
    
    var grump : String {
        mutating get {
            return String(self.characters.dropLast())
        }
    }
    
    func convertJsonStringToDictionary() -> [String: AnyObject]? {
        if let data = self.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
    
    var parseJSONString: Any? {
        
        let data = self.data(using: String.Encoding.utf8, allowLossyConversion: false)
        
        if let jsonData = data {
            // Will return an object or nil if JSON decoding fails
            do {
                return try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers)
            } catch {
                return nil
            }
        } else {
            // Lossless conversion of the string was not possible
            return nil
        }
    }
    
    func formatNumberWithDecimals(_ total: Int) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = total
        formatter.maximumFractionDigits = total
        formatter.alwaysShowsDecimalSeparator = true
        return formatter.string(from: NSNumber(value: Float(self) ?? 0))
    }
    
    func safelyLimitedTo(length n: Int) -> String {
        let c = self.characters
        if (c.count <= n) { return self }
        return String( Array(c).prefix(upTo: n) )
    }
}

// Mark: - CLongClong
extension CLongLong {
    
    var dateFromTimestamp: Date {
        let interval = TimeInterval(self)
        let date = Date(timeIntervalSince1970: interval)
        return date
    }
    
    var dateTimeFromInterval: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:SS"
        return dateFormatter.string(from: self.dateFromTimestamp)
    }
}

// Mark: - Date
extension Date {
    
    var dateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: self)
    }
    
    var timeString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: self)
    }
}

// Mark: - UITextField
extension UITextField {
    
    func clear() {
        self.text = ""
    }
    
    @IBInspectable var maxLength: Int {
        get {
            guard let l = __maxLengths[self] else {
                return Int.max
            }
            return l
        }
        set {
            __maxLengths[self] = newValue
            addTarget(self, action: #selector(fix), for: .editingChanged)
        }
    }
    
    @objc func fix(textField: UITextField) {
        let t = textField.text
        textField.text = t?.safelyLimitedTo(length: maxLength)
    }
}

func delay(_ delay:Double, closure:@escaping ()->()) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}
