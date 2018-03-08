//
//  ClickableLabel.swift
//  Precious
//
//  Created by zhubch on 2018/1/13.
//  Copyright © 2018年 zhubch. All rights reserved.
//

import UIKit

protocol TextConvertible {
    var string: String { get }
    var enableTap: Bool { get }
    var color: UIColor { get }
    var font: UIFont? { get }
}

extension TextConvertible {
    
    var font: UIFont? {
        return nil
    }
}

struct TapableText: TextConvertible {
    var string: String
    var enableTap: Bool {
        return true
    }
    var color: UIColor
    var font: UIFont?
    
    init(string: String, color: UIColor) {
        self.string = string
        self.color = color
    }
}

struct NormalText: TextConvertible {
    var string: String
    var enableTap: Bool {
        return false
    }
    var color: UIColor
    var font: UIFont?
    
    init(string: String, color: UIColor) {
        self.string = string
        self.color = color
    }
}

struct ClickabelModel {
    var text: TextConvertible
    var range: NSRange
}

class ClickableLabel: UILabel {
    
    var textArray: [TextConvertible]? {
        didSet {
            setup()
        }
    }
    
    var models: [ClickabelModel]?
    
    var clickedHandler : ((TextConvertible) -> Void)?
    
    var selectedModel: ClickabelModel? {
        didSet {
            guard let attStr = self.attributedText?.mutableCopy() as? NSMutableAttributedString else {
                return
            }
            guard let range = selectedModel?.range else {
                attStr.removeAttribute(NSAttributedStringKey.backgroundColor, range: NSMakeRange(0, attStr.length))
                self.attributedText = attStr
                return
            }
            attStr.addAttributes([NSAttributedStringKey.backgroundColor:UIColor.lightGray], range: range)
            
            self.attributedText = attStr
        }
    }
    
    func setup() {
        guard let texts = textArray else {
            return
        }
        let attrStr = NSMutableAttributedString()
        models = [ClickabelModel]()
        var loc = 0
        texts.forEach { (text) in
            let attr: [NSAttributedStringKey : Any] = [
                NSAttributedStringKey.foregroundColor : text.color,
                NSAttributedStringKey.font: text.font ?? font!
            ]
            attrStr.append(NSAttributedString(string: text.string, attributes: attr))
            if text.enableTap {
                models?.append(ClickabelModel(text: text, range: NSMakeRange(loc, text.string.length)))
            }
            loc += text.string.length
        }
        
        let style = NSMutableParagraphStyle()
        style.minimumLineHeight = 14
        style.lineSpacing = 3
        style.alignment = .left
        style.lineBreakMode = .byTruncatingTail
        let attr = [
            NSAttributedStringKey.paragraphStyle:style
        ]
        attrStr.addAttributes(attr, range: NSMakeRange(0, attrStr.length))
        
        attributedText = attrStr
        isUserInteractionEnabled = true
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let point = touches.first?.location(in: self),let model = modelAtPoint(point) else {
            return
        }
        selectedModel = model
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let text = selectedModel?.text else {
            return
        }
        clickedHandler?(text)
        selectedModel = nil
    }
    
    open override func touchesCancelled(_ touches: Set<UITouch>?, with event: UIEvent?) {
        selectedModel = nil
    }
    
    override open func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard self.bounds.contains(point) else {
            return super.hitTest(point, with: event)
        }
        if modelAtPoint(point) == nil {
            return nil
        }
        
        return self
    }
    
    fileprivate func modelAtPoint(_ point : CGPoint) -> ClickabelModel? {
        guard let attributedText = self.attributedText else {
            return nil
        }
        let framesetter = CTFramesetterCreateWithAttributedString(attributedText)
        
        let path = CGMutablePath()
        
        path.addRect(self.bounds, transform: CGAffineTransform.identity)
        
        let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, nil)
        
        
        let lines = CTFrameGetLines(frame)
        let count = CFArrayGetCount(lines)
        
        var origins = [CGPoint](repeating: CGPoint.zero, count: count)
        
        CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), &origins)
        
        let transform = CGAffineTransform(translationX: 0, y: self.bounds.size.height).scaledBy(x: 1.0, y: -1.0)
        
        let verticalOffset = 0.0
        
        for i in 0..<count {
            
            let linePoint = origins[i]
            
            let line = CFArrayGetValueAtIndex(lines, i)
            
            let lineRef = unsafeBitCast(line,to: CTLine.self)
            
            var rect = rectWith(line: lineRef, point: linePoint).applying(transform).insetBy(dx: 0, dy: 0).offsetBy(dx: 0, dy: CGFloat(verticalOffset))
            
            var lineSpace: CGFloat = 0.0
            
            if let style = self.attributedText?.attribute(NSAttributedStringKey.paragraphStyle, at: 0, effectiveRange: nil) {
                lineSpace = (style as! NSParagraphStyle).lineSpacing
            }
            
            let lineOutSpace = (self.bounds.size.height - lineSpace * CGFloat(count - 1) - rect.size.height * CGFloat(count)) / 2
            
            rect.origin.y = lineOutSpace + rect.size.height * CGFloat(i) + lineSpace * CGFloat(i)
            rect.y -= 20
            if rect.contains(point) {
                
                let relativePoint = CGPoint(x: point.x - rect.minX, y: point.y - rect.minY)
                
                var index = CTLineGetStringIndexForPosition(lineRef, relativePoint)
                
                var offset: CGFloat = 0.0
                
                CTLineGetOffsetForStringIndex(lineRef, index, &offset)
                
                if offset > relativePoint.x {
                    index = index - 1
                }
                
                guard let models = models else {
                    return nil
                }
                
                for model in models {
                    
                    if NSLocationInRange(index, model.range) {
                        return model
                    }
                }
            }
        }
        
        return nil
    }
    
    fileprivate func rectWith(line: CTLine , point: CGPoint) -> CGRect {
        var ascent: CGFloat = 0.0
        var descent: CGFloat = 0.0
        var leading: CGFloat = 0.0
        
        let width = CTLineGetTypographicBounds(line, &ascent, &descent, &leading)
        
        let height = ascent + fabs(descent) + leading
        return CGRect(x: point.x, y: point.y, width: CGFloat(width), height: height)
    }
    
}


