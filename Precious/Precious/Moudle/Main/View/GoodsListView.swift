//
//  GoodsListView.swift
//  Precious
//
//  Created by zhubch on 2017/12/13.
//  Copyright © 2017年 zhubch. All rights reserved.
//

import UIKit

class GoodsListCell: UIView {
    let imageView = UIImageView()
    let nameLabel = UILabel()
    let priceStepLabel = UILabel()
        
    var good: Goods! {
        didSet {
            imageView.setImageWith(url: good.image)
            imageView.backgroundColor = C.Color.lightGray
            nameLabel.text = good.name
            nameLabel.textColor = C.Color.darkGray
            nameLabel.font = C.Font.normal.M
            imageView.cornerRadius = 8
            priceStepLabel.text = "￥\(good.priceStep) 起拍"
            priceStepLabel.textColor = C.Color.gray
            priceStepLabel.font = C.Font.normal.S
            addSubviews([imageView,nameLabel,priceStepLabel])
            nameLabel.textAlignment = .center
            priceStepLabel.textAlignment = .center
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = CGRect(x: 0, y: 0, w: w, h: w)
        nameLabel.frame = CGRect(x: 0, y: w + 5, w: w, h: 20)
        priceStepLabel.frame = CGRect(x: 0, y: w + 25, w: w, h: 15)
    }
}

class GoodsListView: UIScrollView {
    var didSelectedGoods: ((Goods)->Void)?
    var goods: [Goods]! {
        didSet {
            removeSubviews()
            let w = (C.windowWidth - 32) / 2.7
            let views = goods.map { (good) -> GoodsListCell in
                let v = GoodsListCell(frame: CGRect(x: 0, y: 0, w: w, h: h))
                v.good = good
                v.addTapGesture(action: { ges in
                    let cell = ges.view as! GoodsListCell
                    self.didSelectedGoods?(cell.good)
                })
                return v
            }
            views.forEachEnumerated { (i, v) in
                v.x = i.toCGFloat * (w + 8)
                self.addSubview(v)
            }
            self.contentSize = CGSize(width: views.count.toCGFloat * (w + 8) + 8, height: 0)
        }
    }
}
