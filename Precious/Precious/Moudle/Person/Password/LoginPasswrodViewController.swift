//
//  LoginPasswrodViewController.swift
//  Precious
//
//  Created by zhubch on 2017/12/30.
//  Copyright © 2017年 zhubch. All rights reserved.
//

import UIKit
import RxSwift

class LoginPasswrodViewController: BaseViewController {
    
    var code: String?
    
    @IBOutlet weak var passwordTextField1: TextField!
    @IBOutlet weak var passwordTextField2: TextField!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "修改登录密码"
        view.backgroundColor = C.Color.background
        view.addTapGesture { $0.view?.endEditing(true) }
        
        Observable.combineLatest(passwordTextField1.rx.text, passwordTextField2.rx.text) {
            $0!.length >= 6 && $1!.length >= 6
            }.bind(to: nextButton.rx.isEnabled).disposed(by: self.disposeBag)
        passwordTextField1.becomeFirstResponder()
    }
    
    @IBAction func next(_ sender: UIButton) {
        sender.startLoadingAnimation()
        let router = Router.User.resetPassword(phone: User.current?.phone ?? "", password: passwordTextField2.text!, code: code!)
        API.loadJSON(router) { (response) in
            sender.stopLoadingAnimation()
            if case .success(let json) = response {
                let user = User(json: json)
                user.save()
                self.popVC(count: 2)
            } else if case .failure(let msg) = response {
                showMessage(msg)
            }
        }
    }

}
