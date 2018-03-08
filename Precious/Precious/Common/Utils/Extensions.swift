//
//  WPExtensions.swift
//  WePost
//
//  Created by zhubch on 08/03/2017.
//  Copyright © 2017 happyiterating. All rights reserved.
//

import UIKit
import Kingfisher
import EZSwiftExtensions

let ShouldReplaceFontKey: UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "ShouldReplaceFont".hashValue)

extension Data {
    var toString: String? {
        return String(data: self, encoding: .utf8)
    }
}

extension String {
    var toData: Data {
        return data(using: .utf8)!
    }
    
    var md5Data: Data {
        let messageData = self.data(using:.utf8)!
        var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))
        
        _ = digestData.withUnsafeMutableBytes {digestBytes in
            messageData.withUnsafeBytes {messageBytes in
                CC_MD5(messageBytes, CC_LONG(messageData.count), digestBytes)
            }
        }
        
        return digestData
    }
    
    var md5Hex: String {
        return md5Data.map { String(format: "%02hhx", $0) }.joined()
    }
    
    var md5Base64: String {
        return md5Data.base64EncodedString()
    }
    
    static func random() -> String {
        
        let identifier = CFUUIDCreate(nil)
        let identifierString = CFUUIDCreateString(nil, identifier) as String
        let cStr = identifierString.cString(using: .utf8)
        
        
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        
        CC_MD5(cStr, CC_LONG(strlen(cStr)), &digest)
        
        var output = String()
        
        for i in digest {
            
            output = output.appendingFormat("%02X", i)
        }
        
        return output;
    }
    
    func sizeWith(maxSize: CGSize, font:UIFont) -> CGSize {
        return self.sizeWith(maxSize: maxSize, attributes: [NSAttributedStringKey.font:font])
    }
    
    func sizeWith(maxSize: CGSize, attributes:[NSAttributedStringKey:Any]) -> CGSize {
        return self.toNSString.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: attributes, context: nil).size
    }
    
}


extension NSAttributedString {
    
    public func font(_ font: UIFont) -> NSAttributedString {
        guard let copy = self.mutableCopy() as? NSMutableAttributedString else { return self }
        
        let range = (self.string as NSString).range(of: self.string)
        copy.addAttributes([NSAttributedStringKey.font: font], range: range)
        return copy
    }
    
}

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return 0.0
        }
        set(newValue) {
            layer.cornerRadius = newValue
            layer.masksToBounds = true
        }
    }
    
    @IBInspectable var borderColor: UIColor {
        get {
            return UIColor()
        }
        set(newValue) {
            layer.borderColor = newValue.cgColor
        }
    }
    @IBInspectable var borderWidth: CGFloat {
        get {
            return 0.0
        }
        set(newValue) {
            layer.borderWidth = newValue
            
        }
    }
    
    func showDottedLineBorder(color: UIColor, cornerRadius: CGFloat) {
        let border = CAShapeLayer()
        border.strokeColor = color.cgColor
        border.fillColor = nil
        border.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        border.frame = bounds
        border.lineWidth = 0.5
        border.lineCap = "square"
        border.lineDashPattern = [4,2]
        layer.addSublayer(border)
    }
    
    func makeCorner(_ radius: CGFloat, corners: UIRectCorner = UIRectCorner.allCorners) {
        self.layer.mask = nil
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
    
    convenience init(hexString: String) {
        self.init(frame: CGRect.zero)
        backgroundColor = UIColor(hexString: hexString)
    }
}

extension UIViewController {
    
    func presentNavVC(_ vc: UIViewController) {
//        presentVC(WPNavigationController(rootViewController: vc))
    }
    
    func popVC(count: Int) {
        guard let nav = navigationController else { return }
        
        let vcCount = nav.viewControllers.count
        let to = vcCount - count - 1
        
        guard to > -1, to < vcCount else { return }
        
        let toVC = nav.viewControllers[to]
        
        navigationController?.popToViewController(toVC, animated: true)
    }
    
    func popVC(count: Int, replaceTo vc: UIViewController) {
        guard let nav = navigationController else { return }
        
        let vcCount = nav.viewControllers.count
        let to = vcCount - count - 1
        
        guard to > -1, to < vcCount else { return }
        
        var toVCs = nav.viewControllers.get(at: 0...to)
            toVCs.append(vc)
        
        navigationController?.setViewControllers(toVCs, animated: true)
    }
}

extension UIImageView {
    
    var imageURL: String {
        set {
            setImageWith(url: newValue)
        }
        
        get {
            return ""
        }
    }
    
    func setImageWith(url: String?, placeholder: Image? = nil, completed: ((UIImage?)->Void)? = nil) {
        let imgUrl = URL(string: url ?? "")
        
        kf.setImage(with: imgUrl, placeholder: image) { [weak self] image, error, _, _ in
            if image == nil {
                self?.image = placeholder
            }
            completed?(image)
        }
    }
}

extension UIButton {
    
    func setImage(url: String?, placeholder: Image? = nil, completion:((UIImage?)->Void)? = nil) {
        let imgUrl = URL(string: url ?? "")
        
        kf.setImage(with: imgUrl, for: .normal, placeholder: currentImage, options: nil, progressBlock: { (_, _) in
            //
        }) { (image, _, _, _) in
            completion?(image)
        }
    }
}

extension UIScrollView {
    
    var isReachedTop: Bool {
        return contentOffset.y <= 0
    }
    
    var isReachedBottom: Bool {
        return contentOffset.y >= (contentSize.height - frame.size.height - contentInset.top - contentInset.bottom)
    }
    
    func scrollToBottom(_ space: CGFloat = 0) {
        let offset = contentSize.height - self.h - space
        setContentOffset(CGPoint(x:0,y:max(offset, 0)), animated: true)
    }
    
}


extension UIImage {
    
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        
        self.init(cgImage: cgImage)
    }
    
    func saveToDisk() -> URL {
        
        let fileName = "\(ProcessInfo.processInfo.globallyUniqueString)_file.jpg"
        
        guard let data = UIImageJPEGRepresentation(self, 0.9) else {
            fatalError("Could not convert image to JPEG.")
        }
        
        let fileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        
        guard (try? data.write(to: fileURL, options: [.atomic])) != nil else {
            fatalError("Could not write the image to disk.")
        }
        
        return fileURL
    }
}

struct ColorComponents {
    var r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat
}

extension UIColor {
    
    func getComponents() -> ColorComponents {
        if (self.cgColor.numberOfComponents == 2) {
            let cc = self.cgColor.components!
            return ColorComponents(r:cc[0], g:cc[0], b:cc[0], a:cc[1])
        }
        else {
            let cc = self.cgColor.components!
            return ColorComponents(r:cc[0], g:cc[1], b:cc[2], a:cc[3])
        }
    }
    
    func interpolateRGBColorTo(end: UIColor, fraction: CGFloat) -> UIColor {
        var f = max(0, fraction)
        f = min(1, fraction)
        
        let c1 = self.getComponents()
        let c2 = end.getComponents()
        
        let r = c1.r + (c2.r - c1.r) * f
        let g = c1.g + (c2.g - c1.g) * f
        let b = c1.b + (c2.b - c1.b) * f
        let a = c1.a + (c2.a - c1.a) * f
        
        return UIColor.init(red: r, green: g, blue: b, alpha: a)
    }
    
}

extension UILabel {
    
    func setLineSpacing(lineSpacing: CGFloat, alignment: NSTextAlignment = .left) {
        if let text = text {
            let attributeString = NSMutableAttributedString(string: text)
            let style = NSMutableParagraphStyle()
                style.lineSpacing = lineSpacing
                style.alignment = alignment
                style.lineBreakMode = .byTruncatingTail
            
            attributeString.addAttribute(NSAttributedStringKey.paragraphStyle,
                                         value: style,
                                         range: NSMakeRange(0, text.length))
            
            attributedText = attributeString
        }
    }
    
    func highlight(_ target: String?) {
        guard let text = self.text,let target = target else {
            return
        }
        let attr = [NSAttributedStringKey.foregroundColor:textColor,
                    NSAttributedStringKey.font:font] as [NSAttributedStringKey : Any] 
        
        let attrStr = NSMutableAttributedString(string: text, attributes: attr)
        let range = (text as NSString).range(of: target, options: .caseInsensitive)
        
        attrStr.setAttributes([NSAttributedStringKey.foregroundColor:UIColor(hexString: "A73442")!,
                               NSAttributedStringKey.font:font], range: range)
        attributedText = attrStr
    }
}

extension Bundle {
    
    public class func loadNib<T>(_ name: String, owner: AnyObject!) -> T {
        return Bundle.main.loadNibNamed(name, owner: owner, options: nil)?[0] as! T
    }
    
}

extension CGRect {
    
    var center: CGPoint {
        return CGPoint(x: midX, y: midY)
    }
    
}
