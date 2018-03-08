//
//  AccountViewController.swift
//  Precious
//
//  Created by zhubch on 2018/1/28.
//  Copyright © 2018年 zhubch. All rights reserved.
//

import UIKit

class AccountViewController: BaseViewController {
    
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var toEnterLabel: UILabel!

    var account: Account! {
        didSet {
            totalLabel.text = account.total.toMoney
            balanceLabel.text = account.balanceUsable.toMoney
            toEnterLabel.text = account.admitted.toMoney
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "我的账户"
        self.account = Account.shared
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.account = Account.shared
    }
    
    override func navigationBarDidLoad() {
        super.navigationBarDidLoad()
        navigationBar.rightButtonConfigure1 = NavButtonConfigure(darkImage: #imageLiteral(resourceName: "icon_common_help"), lightImage: #imageLiteral(resourceName: "icon_common_help"), handler: { _ in
        })
    }
    
    @IBAction func cashOut(_ sender: UIButton) {
        
    }
    
    @IBAction func topUp(_ sender: UIButton) {
        
    }
}
