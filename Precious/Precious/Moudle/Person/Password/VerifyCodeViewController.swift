//
//  VerifyCodeViewController.swift
//  Precious
//
//  Created by zhubch on 2017/12/23.
//  Copyright © 2017年 zhubch. All rights reserved.
//

import UIKit

class VerifyViewController: BaseViewController {
    enum Page: String {
        case pay
        case login
    }
    
    var page = Page.login
    
    @IBOutlet weak var codeTextField: TextField!
    @IBOutlet weak var codeNextButton: UIButton!
    @IBOutlet weak var sendAgainButton: UIButton!
    
    let user = User.current!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "重置密码"
        view.backgroundColor = C.Color.background
        view.addTapGesture { $0.view?.endEditing(true) }

        codeTextField.rx.text.map { $0!.length > 3}.bind(to: codeNextButton.rx.isEnabled).disposed(by: disposeBag)

        codeNextButton.setBackgroundColor(C.Color.gold * 0.3, forState: .disabled)
        codeNextButton.setBackgroundColor(C.Color.gold * 0.8, forState: .normal)
        
        phoneNext(self.sendAgainButton)
    }
    
    @IBAction func phoneNext(_ sender: UIButton) {
        sender.startLoadingAnimation()
        let router = Router.User.getVerifyCode(phone: user.phone ?? "")
        API.loadJSON(router) { (response) in
            sender.stopLoadingAnimation()
            if case .success(let json) = response {
                print(json)
                self.codeTextField.becomeFirstResponder()
                time(from: 60).subscribe(onNext: { (time) in
                    self.sendAgainButton.isEnabled = time == 0
                    self.sendAgainButton.titleLabel?.text = "\(time)S"
                    self.sendAgainButton.setTitle("\(time)S", for: .disabled)
                }).disposed(by: self.disposeBag)
            } else if case .failure(let msg) = response {
                showMessage(msg)
            }
        }
    }

    @IBAction func codeNext(_ sender: UIButton) {
        sender.startLoadingAnimation()
        let code = codeTextField.text!
        let router = Router.User.checkVerifyCode(phone: user.phone ?? "", code: code)
        API.loadJSON(router) { (response) in
            sender.stopLoadingAnimation()
            if case .success(let json) = response {
                print(json)
                self.performSegue(withIdentifier: self.page.rawValue, sender: nil)
            } else if case .failure(let msg) = response {
                showMessage(msg)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? PayPasswordViewController {
            vc.page = .newPassword
            vc.code = codeTextField.text!
        } else if let vc = segue.destination as? LoginPasswrodViewController {
            vc.code = codeTextField.text!
        }
    }

}
