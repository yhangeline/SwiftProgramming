//
//  ModifyViewController.swift
//  Precious
//
//  Created by zhubch on 2017/12/21.
//  Copyright © 2017年 zhubch. All rights reserved.
//

import UIKit

class ModifyViewController: BaseViewController {
    enum Page {
        case name
        case bio
        
        var title: String {
            if self == .name {
                return "修改昵称"
            }
            return "修改个人签名"
        }
    }
    
    @IBOutlet weak var textField: UITextField!
    
    var page = Page.name
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = page.title
        
        if page == .bio {
            textField.text = User.current?.signature
        } else {
            textField.text = User.current?.userName
        }
    }
    
    override func navigationBarDidLoad() {
        super.navigationBarDidLoad()
        
        self.navigationBar.rightButtonConfigure1 = NavButtonConfigure(title: "保存", handler: { _ in
            if self.page == .bio {
                User.current?.signature = self.textField.text!
                self.popVC()
            } else {
                self.checkUserName()
            }
        })
    }
    
    func checkUserName() {
        let router = Router.User.check(userName: self.textField.text!)
        API.loadValue(router, valueType: Bool.self) { (response) in
            if case .success(let result) = response {
                if result {
                    User.current?.userName = self.textField.text!
                    self.popVC()
                } else {
                    showMessage("用户名已存在")
                }
            }
        }
    }

}
