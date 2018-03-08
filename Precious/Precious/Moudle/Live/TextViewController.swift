//
//  TextViewController.swift
//  Precious
//
//  Created by zhubch on 2018/1/8.
//  Copyright © 2018年 zhubch. All rights reserved.
//

import UIKit
import RxSwift

class TextViewController: BaseViewController, LiveContent {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var looksLabel: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    
    @IBOutlet weak var goodsAvatar: UIImageView!
    @IBOutlet weak var goodsNameLabel: UILabel!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var secLabel: UILabel!

    var tempBag = DisposeBag()

    var auction: Auction!
    
    var goods: Goods?
    
    var viewModel = TextViewModel()
    
    override var showNavigationBar: Bool {
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        looksLabel.text = auction.looksCount.toString + " 人围观"
        nameLabel.text = auction.userName
        avatar.setImageWith(url: auction.userImage)
        
        tableView.viewModel = viewModel
    }
    
    @IBAction func showGoods(_ sender: UIButton) {
        let v = GoodsInfoView.instance()
        v.goods = self.goods
        popUp(view: v)
    }

    func appendMessage(_ msg: Message) {
        self.viewModel.append(msg)
        self.tableView.scrollToBottom()
    }
    
    func updateGoods(_ goods: Goods?) {
        self.goods = goods
        if let goods = goods {
            goodsNameLabel.text = goods.name
            goodsAvatar.setImageWith(url: goods.image)
            updateCountDown(goods.sellTime ?? 0)
        }
    }
    
    func updateLookers(_ count: Int) {
        looksLabel.text = "\(count) 人围观"
    }
    
    func updateCountDown(_ sec: Int) {
        tempBag = DisposeBag()
        time(from:100).asObservable().map{$0.time}.subscribe(onNext: { (h,m,s) in
            self.hourLabel.text = String(format: "%02d", h)
            self.minLabel.text = String(format: "%02d", m)
            self.secLabel.text = String(format: "%02d", s)
        }).disposed(by: tempBag)
    }
}
