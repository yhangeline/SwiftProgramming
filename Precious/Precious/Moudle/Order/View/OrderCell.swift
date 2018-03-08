//
//  OrderCell.swift
//  Precious
//
//  Created by zhubch on 2018/1/21.
//  Copyright © 2018年 zhubch. All rights reserved.
//

import UIKit

class OrderCell: UITableViewCell {
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var money: UILabel!
    @IBOutlet weak var name: UILabel!
    
    @objc var model: Order! {
        didSet {
            avatar.setImageWith(url: model.image)
            name.text = model.name
            time.text = model.dealTime.toDate?.formatDate
            money.text = model.price.toShortMoney
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
