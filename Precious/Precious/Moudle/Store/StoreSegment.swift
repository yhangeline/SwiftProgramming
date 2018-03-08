//
//  StoreSegment.swift
//  Precious
//
//  Created by zhubch on 2018/1/25.
//  Copyright © 2018年 zhubch. All rights reserved.
//

import UIKit

class StoreSegment: UIView {
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var topSpace: NSLayoutConstraint!

    var buttonGroup: ButtonGroup!
    
    class func instance() -> StoreSegment {
        let v: StoreSegment = Bundle.loadNib("StoreSegment")!
        v.frame = CGRect(x: 0, y: 0, w: C.windowWidth, h: 48)
        return v
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        topSpace.constant = -52
        buttonGroup = ButtonGroup(buttons: [button1,button2])
    }
}
