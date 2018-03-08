//
//  RichText.swift
//  Precious
//
//  Created by zhubch on 2018/1/12.
//  Copyright © 2018年 zhubch. All rights reserved.
//

import UIKit

func range(_ loc: Int, _ len: Int) -> NSRange {
    return NSRange(location: loc, length: len)
}

func + (left: RichText, right: RichText) -> RichText {
    return left.append(right)
}

class RichText {
    fileprivate var ranges = [NSRange]()
    fileprivate var attrStr: NSMutableAttributedString
    
    var toAttributedString: NSAttributedString {
        return attrStr.copy() as! NSAttributedString
    }
    
    var toString: String {
        return attrStr.string
    }
    
    var whole: RichText {
        ranges = [range(0,length)]
        return self
    }
    
    var length: Int {
        return attrStr.length
    }
    
    init(string: String) {
        attrStr = NSMutableAttributedString(string: string)
        ranges = [range(0,length)]
    }
    
    init(attrStr: NSAttributedString) {
        self.attrStr = attrStr.mutableCopy() as! NSMutableAttributedString
        ranges = [range(0,length)]
    }
    
    func addAttributes(_ attr: [NSAttributedStringKey:Any]) -> RichText {
        ranges.forEach {
            attrStr.addAttributes(attr, range: $0)
        }
        return self
    }
    
    func setRange(_ range: NSRange) -> RichText {
        ranges = [range]
        return self
    }
    
    func matches(_ expStr: String) -> RichText {
        ranges = attrStr.string.matchedRanges(expStr)
        return self
    }
    
    func setColor(_ color: UIColor) -> RichText {
        return addAttributes([NSAttributedStringKey.foregroundColor:color])
    }
    
    func setFont(_ font: UIFont) -> RichText {
        return addAttributes([NSAttributedStringKey.font:font])
    }
    
    func append(_ text: RichText) -> RichText {
        attrStr.append(text.attrStr)
        return self
    }
}

protocol RichTextConvertible {
    var rt: RichText { get }
}

extension RichTextConvertible {
    func setRange(_ range: NSRange) -> RichText {
        return rt.setRange(range)
    }
    
    var whole: RichText {
        return rt.whole
    }
    
    func matches(_ expStr: String) -> RichText {
        return rt.matches(expStr)
    }
}

extension String: RichTextConvertible {
    var rt: RichText {
        return RichText(string: self)
    }
}

extension NSAttributedString: RichTextConvertible {
    var rt: RichText {
        return RichText(attrStr: self)
    }
}

extension String {
    func matchedRanges(_ expStr: String) -> [NSRange] {
        guard let exp = try? NSRegularExpression(pattern: expStr, options: .caseInsensitive) else {
            return []
        }
        var ranges = [NSRange]()
        let range = NSRange(location: 0, length: self.length)
        exp.enumerateMatches(in: self, options: .reportCompletion, range: range) { (result, _, _) in
            ranges.append(result!.range)
        }
        return ranges
    }
}

extension UILabel {
    var richText: RichText? {
        get {
            return attributedText?.rt
        }
        set(newValue) {
            attributedText = newValue?.attrStr
        }
    }
}
