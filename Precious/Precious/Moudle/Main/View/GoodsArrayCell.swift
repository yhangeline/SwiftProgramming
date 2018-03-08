//
//  GoodsArrayCell.swift
//  Precious
//
//  Created by zhubch on 2017/12/13.
//  Copyright © 2017年 zhubch. All rights reserved.
//

import UIKit

class GoodsArray: Model {
    var value: [Goods]
    
    
    init(goods: [Goods]) {
        value = goods
        super.init()
    }
}

class GoodsArrayCell: UITableViewCell {
    
    @objc var model: GoodsArray!
    
    @IBOutlet weak var goodsListView: GoodsListView!
    
    var didSelectedGoods: ((Goods)->Void)? {
        didSet {
            goodsListView.didSelectedGoods = didSelectedGoods
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.async {
            self.goodsListView.goods = self.model.value
        }
    }
    
}
