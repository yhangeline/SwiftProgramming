
//
//  PayPasswordViewController.swift
//  Precious
//
//  Created by zhubch on 2017/12/30.
//  Copyright © 2017年 zhubch. All rights reserved.
//

import UIKit

class PayPasswordViewController: BaseViewController {
    
    enum Page {
        case initial
        case originPassword
        case newPassword
        case sure
        
        var next: Page {
            switch self {
            case .initial:
                return .sure
            case .originPassword:
                return .newPassword
            case .newPassword:
                return .sure
            default:
                return .sure
            }
        }

        var title: String {
            switch self {
            case .initial:
                return "设置6位支付密码"
            case .originPassword:
                return "修改6位支付密码，请输入原密码"
            case .newPassword:
                return "输入新6位支付密码"
            default:
                return "确认6位支付密码"
            }
        }
    }
    
    var page = Page.initial
    var code: String?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!

    @IBOutlet weak var codeField1: TextField!
    @IBOutlet weak var codeField2: TextField!
    @IBOutlet weak var codeField3: TextField!
    @IBOutlet weak var codeField4: TextField!
    @IBOutlet weak var codeField5: TextField!
    @IBOutlet weak var codeField6: TextField!
    
    var codeFields: [TextField] {
        return [codeField1, codeField2, codeField3,
                codeField4, codeField5, codeField6]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "支付密码"
        view.backgroundColor = C.Color.background
        view.addTapGesture { $0.view?.endEditing(true) }
        
        resetButton.isHidden = page != .originPassword
        titleLabel.text = page.title
        if page == .sure {
            nextButton.setTitle("确定", for: .normal)
        }
        setupTextField()
        codeField1.becomeFirstResponder()
    }
    
    func setupTextField() {
        codeFields.forEachEnumerated { (i, textField) in
            textField.clearsOnBeginEditing = true
//            textField.didDeleteBackward = { _ in
//                if (textField.text?.length ?? 0) ==  0  && i > 0 {
//                    self.codeFields[i-1].becomeFirstResponder()
//                }
//            }
            textField.rx
                .controlEvent(.editingChanged)
                .takeUntil(self.rx.deallocated)
                .subscribe(onNext: { () in
                    let text = textField.text ?? ""
                    if text.length == 0 && i > 0 {
                        self.codeFields[i-1].becomeFirstResponder()
                    } else if text.length > 0 && i < 5 {
                        self.codeFields[i+1].becomeFirstResponder()
                    } else if text.length == 1 && i == 5 {
                        self.codeFields[i].resignFirstResponder()
                    } else if text.length > 1 {
                        textField.text = text[0..<1]
                    }
                })
                .disposed(by: self.disposeBag)
            
        }
    }
    
    @IBAction func next(_ sender: UIButton) {
        if case .sure = page {
            return
        }
        performSegue(withIdentifier: "next", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? VerifyViewController {
            vc.page = .pay
        } else if let vc = segue.destination as? PayPasswordViewController {
            vc.page = page.next
        }

    }

}
