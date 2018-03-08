//
//  BidPriceView.swift
//  Precious
//
//  Created by zhubch on 2018/1/15.
//  Copyright © 2018年 zhubch. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class BidPriceView: UIView {
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var sureButton: BlockButton!
    
    var goods: Goods! {
        didSet {
            initPrice = goods.initPrice
        }
    }
    
    var auction: Auction!
    
    var completionHandler: ((BidPriceView)->Void)?
    
    var currentPrice = 0 {
        didSet {
            priceLabel.text = currentPrice.toShortMoney
        }
    }
    
    var initPrice = 0 {
        didSet {
            currentPrice = initPrice
        }
    }
    
    class func instance() -> BidPriceView {
        let v: BidPriceView = Bundle.loadNib("BidPriceView")!
        v.frame = CGRect(x: 0, y: 0, w: C.windowWidth, h: 66)
        return v
    }
    
    @IBAction func bid(_ sender: UIButton) {

        API.loadJSON(Router.Order.bid(goodsId: goods.id, price: currentPrice, auctionId: auction.id)) { (response) in
            if case .success(let json) = response {
                print(json)
                self.completionHandler?(self)
            } else if case .failure(let err) = response {
                showMessage(err)
            }
        }
    }
    
    @IBAction func add(_ sender: UIButton) {
        currentPrice += goods.priceStep
    }
    
    @IBAction func subtract(_ sender: UIButton) {
        currentPrice = max(currentPrice - goods.priceStep, initPrice)
    }

}
