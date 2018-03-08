//
//  UIButton+Color.swift
//  Precious
//
//  Created by zhubch on 2017/12/23.
//  Copyright © 2017年 zhubch. All rights reserved.
//

import UIKit

let ButtonSelectedColorKey: UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "ButtonHighlightColor".hashValue)
let ButtonNormalColorKey: UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "ButtonNormalColorKey".hashValue)
let ButtonDisabledColorKey: UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "ButtonDisabledColorKey".hashValue)

extension UIButton {
 
    @IBInspectable var selectedColor: UIColor {
        get {
            guard let ret =  objc_getAssociatedObject(self, ButtonSelectedColorKey) as? UIColor else {
                return .clear
            }
            return ret
        }
        set(newValue) {
            objc_setAssociatedObject(self, ButtonSelectedColorKey, newValue, .OBJC_ASSOCIATION_COPY)
            setBackgroundColor(newValue, forState: .highlighted)
            setBackgroundColor(newValue, forState: .selected)
        }
    }
    
    @IBInspectable var normalColor: UIColor {
        get {
            guard let ret =  objc_getAssociatedObject(self, ButtonNormalColorKey) as? UIColor else {
                return .clear
            }
            return ret
        }
        set(newValue) {
            objc_setAssociatedObject(self, ButtonNormalColorKey, newValue, .OBJC_ASSOCIATION_COPY)
            setBackgroundColor(newValue, forState: .normal)
        }
    }
    
    @IBInspectable var disabledColor: UIColor {
        get {
            guard let ret =  objc_getAssociatedObject(self, ButtonDisabledColorKey) as? UIColor else {
                return .clear
            }
            return ret
        }
        set(newValue) {
            objc_setAssociatedObject(self, ButtonDisabledColorKey, newValue, .OBJC_ASSOCIATION_COPY)
            setBackgroundColor(newValue, forState: .disabled)
        }
    }
}
