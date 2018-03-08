//
//  GoodsInfoView.swift
//  Precious
//
//  Created by zhubch on 2018/1/13.
//  Copyright © 2018年 zhubch. All rights reserved.
//

import UIKit

class GoodsInfoView: UIView {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var initPrice: UILabel!
    @IBOutlet weak var deposit: UILabel!
    @IBOutlet weak var marketPrice: UILabel!
    @IBOutlet weak var priceStep: UILabel!
    @IBOutlet weak var detail: UITextView!

    var goods: Goods! {
        didSet {
            name.text = goods.name
            initPrice.text = goods.initPrice.toString
            deposit.text = "接口没有"
            marketPrice.text = goods.marketPrice.toShortMoney
            priceStep.text = goods.priceStep.toShortMoney
            detail.text = goods.remark
        }
    }
    

    class func instance() -> GoodsInfoView {
        let v: GoodsInfoView = Bundle.loadNib("GoodsInfoView")!
        v.frame = CGRect(x: 0, y: 0, w: 295, h: 429)
        v.cornerRadius = 8
        return v
    }
    
}
