//
//  BannersCell.swift
//  Precious
//
//  Created by zhubch on 2017/12/13.
//  Copyright © 2017年 zhubch. All rights reserved.
//

import UIKit

class BannerArray: Model {
    var value: [Banner]
    init(banners: [Banner]) {
        value = banners
        super.init()
    }
}

class BannersCell: UITableViewCell {
    
    @objc var model: BannerArray! {
        didSet {
            bannerView.images = model.value.map{$0.bannerImg ?? ""}
        }
    }
    
    @IBOutlet weak var bannerView: BannerView!

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

