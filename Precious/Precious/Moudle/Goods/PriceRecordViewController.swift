//
//  PriceRecordViewController.swift
//  Precious
//
//  Created by zhubch on 2018/1/24.
//  Copyright © 2018年 zhubch. All rights reserved.
//

import UIKit

class PriceRecordViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var deposit: UILabel!
    @IBOutlet weak var marketPrice: UILabel!
    @IBOutlet weak var priceStep: UILabel!
    @IBOutlet weak var bidCount: UILabel!
    
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var secLabel: UILabel!
    
    @IBOutlet weak var bidContainer: UIView!

    let bidView = BidPriceView.instance()

    var auction: Auction!
    
    var goods: Goods!
    
    var viewModel = TextViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "出价记录"
        setupView()
    }
    
    func setupView() {
        
        price.text = goods!.currentPrice.toShort
        deposit.text = "接口没有"
        marketPrice.text = goods.marketPrice.toShortMoney
        priceStep.text = goods.priceStep.toShortMoney
        bidCount.text = "接口没有"
        time(from:100).asObservable().map{$0.time}.subscribe(onNext: { (h,m,s) in
            self.hourLabel.text = String(format: "%02d", h)
            self.minLabel.text = String(format: "%02d", m)
            self.secLabel.text = String(format: "%02d", s)
        }).disposed(by: disposeBag)

        bidView.auction = self.auction
        bidView.goods = self.goods
        bidContainer.addSubview(bidView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bidView.frame = bidContainer.bounds
    }
}
