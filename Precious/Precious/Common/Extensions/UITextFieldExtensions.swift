//
//  UITextField+Placeholder.swift
//  Precious
//
//  Created by zhubch on 2018/1/1.
//  Copyright © 2018年 zhubch. All rights reserved.
//

import UIKit

extension UITextField {
    @IBInspectable var leftSpace: CGFloat {
        get {
            return 0.0
        }
        set(newValue) {
            leftView = UIView(x: 0, y: 0, w: newValue, h: bounds.height)
            leftViewMode = .always
        }
    }
    
    @IBInspectable var placeholderColor: UIColor? {
        get {
            return placeholderLabel?.textColor
        }
        set {
            placeholderLabel?.textColor = newValue
        }
    }
    
    var placeholderLabel: UILabel? {
        return value(forKey: "_placeholderLabel") as? UILabel
    }
}
