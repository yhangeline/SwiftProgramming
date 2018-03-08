//
//  LimitsArrayCell.swift
//  Precious
//
//  Created by zhubch on 2017/12/13.
//  Copyright © 2017年 zhubch. All rights reserved.
//

import UIKit

class LimitArray: Model {
    var value: [Auction]
    init(limits: [Auction]) {
        value = limits
        super.init()
    }
}

class LimitsArrayCell: UITableViewCell {
    
    var didSelectedAuction: ((Auction)->Void)?

    @objc var model: LimitArray! {
        didSet {
            let w = (C.windowWidth - 42) * 0.5
            let h = w * 1.37
            if model.value.count == 0 {
                return
            }
            self.pannel.removeSubviews()
            model.value.forEachEnumerated { (i, auction) in
                let v = LimitTimeCell.instance()
                v.frame = CGRect(x: (i%2).toCGFloat * (w + 10) + 16, y: (i/2).toCGFloat * (h + 10) , width: w, height: h)
                v.model = auction
                v.addTapGesture(action: { [unowned self] _ in
                    self.didSelectedAuction?(auction)
                })
                self.pannel.addSubview(v)
            }
            pannelHeight.constant = ((model.value.count - 1) / 2 + 1).toCGFloat * h + 22
        }
    }
    
    @IBOutlet weak var pannel: UIView!
    @IBOutlet weak var pannelHeight: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
    
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
