//
//  PayDepositViewController.swift
//  Precious
//
//  Created by zhubch on 2018/2/4.
//  Copyright © 2018年 zhubch. All rights reserved.
//

import UIKit

class PayDepositViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    let items = [(#imageLiteral(resourceName: "icon_account_balance"),"使用余额",#selector(balance)),
                 (#imageLiteral(resourceName: "icon_account_wechat"),"使用微信",#selector(wechat)),
                 (#imageLiteral(resourceName: "icon_account_alipay"),"使用支付宝",#selector(alipay)),
                 (#imageLiteral(resourceName: "icon_account_outline"),"线下充值",#selector(outline))]
    @IBOutlet weak var depositLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "缴纳保证金"
    }
    
    override func navigationBarDidLoad() {
        super.navigationBarDidLoad()
        navigationBar.rightButtonConfigure1 = NavButtonConfigure(darkImage: #imageLiteral(resourceName: "icon_common_help"), lightImage: #imageLiteral(resourceName: "icon_common_help"), handler: { _ in
        })
    }
    
    @objc func balance() {
    }
    
    @objc func wechat() {
    }
    
    @objc func alipay() {
    }
    
    @objc func outline() {
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "deposit", for: indexPath)
        let item = items[indexPath.row]
        cell.imageView?.image = item.0
        cell.textLabel?.text = item.1
        cell.detailTextLabel?.text = ""
        if item.1 == "使用余额" {
            cell.detailTextLabel?.text = "可用余额" + Account.shared.balanceUsable.toMoney
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        perform(item.2)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
}
