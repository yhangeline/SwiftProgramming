//
//  PersonViewController.swift
//  Precious
//
//  Created by zhubch on 2017/12/20.
//  Copyright © 2017年 zhubch. All rights reserved.
//

import UIKit

class PersonViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var followCountLabel: UILabel!
    @IBOutlet weak var followerCountLabel: UILabel!
    
    @IBOutlet weak var moneyLabel: UIButton!
    @IBOutlet weak var creditLabel: UIButton!
    
    let items = [("我参与的",#selector(takePart)),
                 ("我是商家",#selector(trader)),
                 ("实名认证",#selector(identity)),
                 ("更多",#selector(menu))]

    override func viewDidLoad() {
        super.viewDidLoad()

        User.current?.refresh{ _ in
            self.setupUI()
        }
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }

    func setupUI() {
        avatarView.setImageWith(url: User.current?.image)
        nameLabel.text = User.current?.userName ?? "甄友"
        followCountLabel.text = "关注 \(User.current?.followCount ?? 0)"
        followerCountLabel.text = "粉丝 \(User.current?.followerCount ?? 0)"
        
        Account.shared.refresh { (account) in
            self.moneyLabel.setTitle(account.total.toShort, for: .normal)
            self.creditLabel.setTitle(account.admitted.toShort, for: .normal)
        }
    }
    
    @objc func takePart() {
        performSegue(withIdentifier: "take_part", sender: nil)
    }
    
    @objc func trader() {
        performSegue(withIdentifier: "store", sender: nil)
    }
    
    @objc func identity() {
        let status = User.current?.idPass ?? 0

        if status == 0 {
            performSegue(withIdentifier: "identity", sender: nil)
        }
    }
    
    @objc func menu() {
        performSegue(withIdentifier: "menu", sender: nil)
    }

}

extension PersonViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "person", for: indexPath)
        let item = items[indexPath.row]
        cell.textLabel?.text = item.0
        cell.detailTextLabel?.text = ""
        if item.0 == "实名认证" {
            let status = User.current?.idPass ?? 0
            let desc = ["未认证","审核中","已认证"]
            cell.detailTextLabel?.text = desc[status]

            if status == 2 {
                cell.detailTextLabel?.textColor = C.Color.lightGray
            }
        }
        let accessoryView = UIImageView(image: #imageLiteral(resourceName: "icon_home_more"))
        cell.accessoryView = accessoryView
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        perform(item.1)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
}
