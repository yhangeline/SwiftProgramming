//
//  MyStoreViewController.swift
//  Precious
//
//  Created by zhubch on 2017/12/31.
//  Copyright © 2017年 zhubch. All rights reserved.
//

import UIKit

class MyStoreViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var bigAvatarView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var followCountLabel: UILabel!
    @IBOutlet weak var followerCountLabel: UILabel!
    
    @IBOutlet weak var dealAcountLabel: UILabel!
    @IBOutlet weak var dealTotalLabel: UILabel!
    @IBOutlet weak var dealRateLabel: UILabel!
    @IBOutlet weak var returnRateLabel: UILabel!
    @IBOutlet weak var commentsRateLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    
    var store: Store?
    
    let items = [("计时拍",#selector(limit)),
                 ("我的宝贝",#selector(goods)),
                 ("订单管理",#selector(order)),
                 ("宝贝评价",#selector(rate))]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData()
    }
    
    override func navigationBarDidLoad() {
        super.navigationBarDidLoad()
        self.navigationBar.alpha = 0
        tableView.rx.contentOffset.map {
            let offset = max($0.y , 0)
            return offset / (200 - C.statusBarHeight - 44)
            }.bind(to: navigationBar.rx.alpha).disposed(by: disposeBag)
    }
    
    func loadData() {
        startLoadingAnimation()
        let router = Router.Store.myStore
        API.loadJSON(router) { (response) in
            self.stopLoadingAnimation()
            if case .success(let json) = response {
                self.store = Store(json: json)
                self.setupUI()
            } else if case .failure(let err) = response{
                showMessage(err)
            }
        }
    }
    
    func setupUI() {
        title = store?.storeName ?? "--"
        nameLabel.text = title
        avatarView.setImageWith(url: store?.storeLogo, placeholder: #imageLiteral(resourceName: "img_default_head"))
        bigAvatarView.setImageWith(url: store?.storeLogo, placeholder: #imageLiteral(resourceName: "img_default_head"))
        followCountLabel.text = "关注 \(User.current?.followCount ?? 0)"
        followerCountLabel.text = "粉丝 \(User.current?.followerCount ?? 0)"
        
        dealAcountLabel.text = store?.dealAcount.toString
        dealTotalLabel.text = store?.dealTotal.toString
        dealRateLabel.text = store?.dealRate.toString
        returnRateLabel.text = store?.returnRate.toString
        commentsRateLabel.text = store?.satisfy.toString
        levelLabel.text = store?.level.toString
    }
    
    @IBAction func auctions(_ sender: Any) {
        performSegue(withIdentifier: "auctions", sender: self)
    }
    
    @objc func limit() {
        
    }
    
    @objc func goods() {
        performSegue(withIdentifier: "goods", sender: self)
    }
    
    @objc func order() {
        
    }
    
    @objc func rate() {
        
    }
}

extension MyStoreViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "store", for: indexPath)
        let item = items[indexPath.row]
        cell.textLabel?.text = item.0
        cell.detailTextLabel?.text = ""
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
