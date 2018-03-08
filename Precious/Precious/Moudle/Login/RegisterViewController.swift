//
//  RegisterViewController.swift
//  Precious
//
//  Created by zhubch on 2017/12/12.
//  Copyright © 2017年 zhubch. All rights reserved.
//

import UIKit
import RxSwift

class RegisterViewController: BaseViewController {

    enum Page: String {
        case register
        case resetPassword
        case bindPhone
        
        var title: String {
            switch self {
            case .register:
                return "注册"
            case .bindPhone:
                return "绑定手机号"
            default:
                return "重置密码"
            }
        }
    }
    
    var page: Page!
    
    var phone = ""
    var code = ""
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var phoneTextField: TextField!
    @IBOutlet weak var phoneNextButton: UIButton!
    
    @IBOutlet weak var codeTextField: TextField!
    @IBOutlet weak var codeNextButton: UIButton!
    @IBOutlet weak var sendAgainButton: UIButton!

    @IBOutlet weak var passwordTextField1: TextField!
    @IBOutlet weak var passwordTextField2: TextField!
    @IBOutlet weak var passwordNextButton: UIButton!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var shouldBack: Bool {
        let index = (Int(scrollView.contentOffset.x) + 10) / Int(C.windowWidth)
        if index > 0 {
            self.scrollView.setContentOffset(CGPoint(x: Int(C.windowWidth) * (index - 1), y: 0), animated: true)
            return false
        }
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addTapGesture { $0.view?.endEditing(true) }

        phoneTextField.rx.text.map { $0!.length > 10}.bind(to: phoneNextButton.rx.isEnabled).disposed(by: disposeBag)
        codeTextField.rx.text.map { $0!.length > 3}.bind(to: codeNextButton.rx.isEnabled).disposed(by: disposeBag)
        Observable.combineLatest(passwordTextField1.rx.text, passwordTextField2.rx.text) {
            $0!.length >= 6 && $1!.length >= 6
            }.bind(to: passwordNextButton.rx.isEnabled).disposed(by: self.disposeBag)
        
        phoneNextButton.setBackgroundColor(C.Color.gold * 0.3, forState: .disabled)
        phoneNextButton.setBackgroundColor(C.Color.gold * 0.8, forState: .normal)
        
        codeNextButton.setBackgroundColor(C.Color.gold * 0.3, forState: .disabled)
        codeNextButton.setBackgroundColor(C.Color.gold * 0.8, forState: .normal)
        
        passwordNextButton.setBackgroundColor(C.Color.gold * 0.3, forState: .disabled)
        passwordNextButton.setBackgroundColor(C.Color.gold * 0.8, forState: .normal)

        titleLabel.text = page.title
        passwordNextButton.setTitle(page.title, for: .normal)
        phoneTextField.becomeFirstResponder()
    }
    
    override func navigationBarDidLoad() {
        super.navigationBarDidLoad()
        navigationBar.isHidden = true
    }

    @IBAction func phoneNext(_ sender: UIButton) {
        sender.startLoadingAnimation()
        phone = phoneTextField.text!
        var router = Router.User.getVerifyCodeForRegister(phone: phone)
        if page == .resetPassword {
            router = Router.User.getVerifyCode(phone: phone)
        }
        API.loadJSON(router) { (response) in
            sender.stopLoadingAnimation()
            if case .success(let json) = response {
                print(json)
                self.sendAgainButton.isEnabled = false
                self.phoneNextButton.isEnabled = false
                self.sendAgainButton.setTitle("60S", for: .disabled)
                time(from: 60).subscribe(onNext: { (time) in
                    self.sendAgainButton.titleLabel?.text = "\(time)S"
                    self.sendAgainButton.setTitle("\(time)S", for: .disabled)
                    if time == 0 {
                        self.sendAgainButton.isEnabled = true
                        self.phoneNextButton.isEnabled = true
                    }
                }).disposed(by: self.disposeBag)
                self.codeTextField.becomeFirstResponder()
                self.scrollView.setContentOffset(CGPoint(x: C.windowWidth, y: 0), animated: true)
            } else if case .failure(let msg) = response {
                showMessage(msg)
            }
        }
    }
    
    @IBAction func codeNext(_ sender: UIButton) {
        sender.startLoadingAnimation()
        code = codeTextField.text!
        
        var router = Router.User.checkVerifyCode(phone: phone, code: code)
        if page == .bindPhone {
            router = Router.User.bindPhone(phone: phone, code: code)
        }
        API.loadJSON(router) { (response) in
            sender.stopLoadingAnimation()
            if case .success(let json) = response {
                User.current?.setValue(with: json)
                self.passwordTextField1.becomeFirstResponder()
                self.scrollView.setContentOffset(CGPoint(x: C.windowWidth * 2, y: 0), animated: true)
            } else if case .failure(let msg) = response {
                showMessage(msg)
            }
        }
    }
    
    @IBAction func passwordNext(_ sender: UIButton) {
        guard passwordTextField1.text! == passwordTextField2.text! else {
            showMessage("密码不一致")
            return
        }
        sender.startLoadingAnimation()
        var router = Router.User.resetPassword(phone: phone, password: passwordTextField2.text!, code: code)
        if page == .register {
            router = Router.User.register(phone: phone, password: passwordTextField2.text!, code: code)
        }
        API.loadJSON(router) { (response) in
            sender.stopLoadingAnimation()
            if case .success(let json) = response {
                let user = User(json: json)
                user.save()
                print(json)
                self.performSegue(withIdentifier: "finish", sender: nil)
            } else if case .failure(let msg) = response {
                showMessage(msg)
            }
        }
    }
}
