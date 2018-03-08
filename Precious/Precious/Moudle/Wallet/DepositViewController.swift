//
//  DepositViewController.swift
//  Precious
//
//  Created by zhubch on 2018/1/28.
//  Copyright © 2018年 zhubch. All rights reserved.
//

import UIKit
import RxSwift

class DepositViewController: BaseViewController {
    
    @IBOutlet weak var depositLabel: UILabel!
    @IBOutlet weak var freezeLabel: UILabel!
    
    let input = Variable("")
    var bag = DisposeBag()
    var account: Account! {
        didSet {
            depositLabel.text = account.deposit.toMoney
            freezeLabel.text = account.freeze.toMoney
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "保证金"
        self.account = Account.shared
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.account = Account.shared
    }

    @IBAction func cashOut(_ sender: UIButton) {
        showAlert(title: "请输入提现金额", message: nil, actionTitles: ["取消","确定"], textFieldconfigurationHandler: { textField in
            self.bag = DisposeBag()
            textField.rx.text.map{ $0 ?? "" }.bind(to: self.input).disposed(by: self.bag)
        }) { index in
            if index == 0 {
                return
            }
            guard let amt = self.input.value.toDouble() else {
                showMessage("金额输入有误")
                return
            }
            API.loadJSON(Router.Wallet.depositDraw(amount: amt), completionHandler: { (response) in
                if case .success(let json) = response {
                    print(json)
                } else if case .failure(let msg) = response {
                    showMessage(msg)
                }
            })
        }
    }

}
