//
//  WalletViewController.swift
//  Precious
//
//  Created by zhubch on 2018/1/22.
//  Copyright © 2018年 zhubch. All rights reserved.
//

import UIKit

class WalletViewController: BaseViewController {
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var creditLabel: UILabel!
    @IBOutlet weak var depositLabel: UILabel!
    
    var account: Account! {
        didSet {
            totalLabel.text = account.balanceUsable.toMoney
            depositLabel.text = account.deposit.toMoney
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "我的钱包"
        self.account = Account.shared
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.account = Account.shared
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.account = Account.shared
    }

    func topUp(_ sender: UIButton) {
        showActionSheet(title: "请选择充值方式", message: nil, actionTitles: ["使用微信支付","使用支付宝","线下充值"]) { index in
            switch index {
            case 0:
                self.wxPay()
            case 1:
                self.aliPay()
            default:
                break
            }
        }
    }
    
    func wxPay() {
        API.loadJSON(Router.Wallet.wxPay(dest: 1, amount: 1)) { (response) in
            if case .success(let json) = response {
                let req = PayReq()
                req.prepayId = json["prepayid"].string
                req.partnerId = json["partnerid"].string
                req.timeStamp = UInt32((json["timestamp"].string?.toInt())!)
                req.sign = json["sign"].string
                req.package = json["package"].string
                req.nonceStr = json["noncestr"].string
                WXApi.send(req)
            } else if case .failure(let err) = response {
                showMessage(err)
            }
        }
    }
    
    func aliPay() {
        API.loadJSON(Router.Wallet.aliPay(dest: 1, amount: 0.1)) { (response) in
            if case .success(let json) = response {
                AlipaySDK.defaultService().payOrder(json["orderString"].string!, fromScheme: "zhenbaoshijie", callback: { (result) in
                    print(result!)
                })
            } else if case .failure(let err) = response {
                showMessage(err)
            }
        }
    }
}
