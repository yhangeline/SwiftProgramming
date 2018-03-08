//
//  LoginViewController.swift
//  Precious
//
//  Created by zhubch on 2017/12/6.
//  Copyright © 2017年 zhubch. All rights reserved.
//

import UIKit
import RxSwift
class LoginViewController: UIViewController {
    
    @IBOutlet weak var phoneTextField: TextField!
    @IBOutlet weak var passwordTextField: TextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var topSpace: NSLayoutConstraint!

    let logoView = UIImageView(image: #imageLiteral(resourceName: "img_login_logo"))
    let titleLabel = UILabel(font: C.Font.normal.M, color: C.Color.white, alignment: .left)
    
    var timer: Timer?
    
    
    var focoused: Bool = false {
        didSet {
            if focoused {
                focousAnimate()
            } else {
                unfocouAnimate()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Observable.combineLatest(phoneTextField.rx.text, passwordTextField.rx.text) {
            $0!.length >= 11 && $1!.length >= 6
        }.bind(to: nextButton.rx.isEnabled).disposed(by: self.disposeBag)
        
        phoneTextField.text = User.current?.phone
        nextButton.setBackgroundColor(C.Color.gold * 0.3, forState: .disabled)
        nextButton.setBackgroundColor(C.Color.gold * 0.8, forState: .normal)
        view.addTapGesture { $0.view?.endEditing(true) }
        
        logoView.frame = CGRect(x: (C.windowWidth - 164) * 0.5, y: 123, w: 164, h: 42)
        titleLabel.frame = CGRect(x: 32, y: 88, w: 60, h: 33)
        titleLabel.text = "登录"
        titleLabel.alpha = 0
        
        view.addSubview(logoView)
        view.addSubview(titleLabel)
        
        timer = Timer.runThisEvery(seconds: 0.1) { _ in
            let focoused = self.phoneTextField.isFirstResponder || self.passwordTextField.isFirstResponder
            if focoused != self.focoused {
                self.focoused = focoused
            }
        }
    }
    
    func focousAnimate() {
        topSpace.constant = 150
        UIView.animate(withDuration: 0.5) {
            self.titleLabel.alpha = 1
            self.logoView.alpha = 0
            self.logoView.frame = CGRect(x: 32, y: 88, w: 164 * 0.3, h: 42 * 0.3)
            self.view.layoutIfNeeded()
        }
    }
    
    func unfocouAnimate() {
        topSpace.constant = 175
        UIView.animate(withDuration: 0.5) {
            self.titleLabel.alpha = 0
            self.logoView.alpha = 1
            self.logoView.frame = CGRect(x: (C.windowWidth - 164) * 0.5, y: 123, w: 164, h: 42)
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func login(_ sender: UIButton) {
        sender.startLoadingAnimation()
        let router = Router.User.login(phone: phoneTextField.text!, password: passwordTextField.text!)
        API.loadJSON(router) { (response) in
            sender.stopLoadingAnimation()
            if case .success(let json) = response {
                let user = User(json: json)
                user.save()
                self.performSegue(withIdentifier: "finish", sender: nil)
            } else if case .failure(let msg) = response {
                showMessage(msg)
            }
        }
    }
    
    @IBAction func resetPassword(_ sender: UIButton) {
        performSegue(withIdentifier: "resetPassword", sender: sender)
    }
    
    @IBAction func register(_ sender: UIButton) {
        performSegue(withIdentifier: "register", sender: sender)
    }
    
    @IBAction func wechatLogin(_ sender: UIButton) {
        startLoadingAnimation()
        let req = SendAuthReq()
        req.scope = "snsapi_userinfo"
        req.state = "org.wepost.wechatlogin"
        WXApi.send(req)
        
        var ob: Any? = nil
        ob = WeChatCompleted.observe { (resp) in
            if resp.errCode == 0 {
                API.loadJSON(Router.User.wxLogin(code: resp.code), completionHandler: { (response) in
                    if case .success(let json) = response {
                        let user = User(json: json)
                        user.save()
                        if user.isTemp {
                            self.performSegue(withIdentifier: "bindPhone", sender: sender)
                        } else {
                            self.performSegue(withIdentifier: "finish", sender: nil)
                        }
                    } else if case .failure(let err) = response {
                        showMessage(err)
                    }
                    self.stopLoadingAnimation()
                })
            }
            if ob != nil {
                WeChatCompleted.removeObserver(ob!)
            }
        }
    }
    
    func loginWith(userInfo: [String:Any]) {
        print(userInfo)
    }
    
    @IBAction func dismiss(_ sender: UIButton) {
        self.dismissVC(completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? RegisterViewController else { return }
        vc.page = RegisterViewController.Page(rawValue: segue.identifier!)!
    }
}
