//
//  DealView.swift
//  Precious
//
//  Created by zhubch on 2018/1/15.
//  Copyright © 2018年 zhubch. All rights reserved.
//

import UIKit

class DealView: UIView {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var price: UILabel!

    class func instance() -> DealView {
        let v: DealView = Bundle.loadNib("DealView")!
        v.frame = CGRect(x: 0, y: 0, w: 310, h: 325)
        return v
    }
}
