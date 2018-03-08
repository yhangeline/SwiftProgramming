//
//  SimpleGoodsCell.swift
//  Precious
//
//  Created by zhubch on 2017/12/23.
//  Copyright © 2017年 zhubch. All rights reserved.
//

import UIKit

class SimpleGoodsCell: UITableViewCell {

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var goodName: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var initPrice: UILabel!
    @IBOutlet weak var selectedButton: UIButton!
    @IBOutlet weak var leftSpace: NSLayoutConstraint!

    var selectMode = false {
        didSet {
            selectedButton.isHidden = selectMode.toggled
            leftSpace.constant = selectMode ? 6 : 16
        }
    }
    
    @objc var model: Goods! {
        didSet {
            avatar.setImageWith(url: model.image)
            goodName.text = model.name
            initPrice.text = "￥ \(model.initPrice.toShort)"
            price.text = "￥ --"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectMode = false
    }
    
    @IBAction func selectGoods(_ sender: UIButton) {
        sender.isSelected = sender.isSelected.toggled
        model.selected = sender.isSelected 
    }
}
