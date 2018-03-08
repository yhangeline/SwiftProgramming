//
//  UIViewController+Alert.swift
//  Precious
//
//  Created by zhubch on 2017/12/23.
//  Copyright © 2017年 zhubch. All rights reserved.
//

import UIKit

extension UIAlertAction {
    var titleColor: UIColor? {
        get {
            return value(forKey: "titleTextColor") as? UIColor
        }
        set(newValue) {
            setValue(newValue, forKey: "titleTextColor")
        }
    }
}

extension UIViewController {
    @discardableResult
    func showAlert(title: String,
                   message: String? = nil,
                   actionTitles: [String] = [],
                   textFieldconfigurationHandler: ((UITextField) -> Void)?  = nil,
                   actionHandler: ((Int) -> Void)?  = nil) -> UIAlertController{
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for (index, actionTitle) in actionTitles.enumerated() {
            alert.addAction(UIAlertAction(title: actionTitle, style: index == 0 ? .cancel : .default, handler: { action in
                actionHandler?(index)
            }))
        }
        if actionTitles.isEmpty {
            alert.addAction(UIAlertAction(title: "好，知道了", style: .cancel, handler: nil))
        }
        if let _ = textFieldconfigurationHandler {
            alert.addTextField(configurationHandler: textFieldconfigurationHandler)
        }
        presentVC(alert)
        return alert
    }
    
    func showActionSheet(title: String? = nil,
                         message: String? = nil,
                         actionTitles: [String],
                         actionHandler: ((Int) -> Void)?){
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        alert.message = message
        for (index, actionTitle) in actionTitles.enumerated() {
            alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { action in
                actionHandler?(index)
            }))
        }
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        presentVC(alert)
    }
    
    func doAfterUserSure(title:String, sureTitle:String = "确认", block:@escaping ()->Void) {
        showAlert(title: title, message: nil, actionTitles: ["取消",sureTitle]) { (index) in
            if index == 1 {
                block()
            }
        }
    }
}
