//
//  CashOutViewController.swift
//  Precious
//
//  Created by zhubch on 2018/2/3.
//  Copyright © 2018年 zhubch. All rights reserved.
//

import UIKit

class CashOutViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "提现"
    }

    @IBAction func chooseAddress(_ sender: UIButton) {
        popUp(AddressPickerView()) { (v) in

        }
    }

}
