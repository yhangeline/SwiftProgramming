//
//  LimitTimeCell.swift
//  Precious
//
//  Created by zhubch on 2018/1/20.
//  Copyright © 2018年 zhubch. All rights reserved.
//

import UIKit

class LimitTimeCell: UICollectionViewCell {

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var salesName: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var looksCount: UILabel!
    @IBOutlet weak var biddingCount: UILabel!
    @IBOutlet weak var timeBg: UIView!

    @objc var model: Auction! {
        didSet {
            avatar.setImageWith(url: model.image)
            salesName.text = model.salesName
            timeLabel.text = "距离结束 \(model.endTime?.toDate?.leftTime ?? "--")"
            looksCount.text = model.looksCount.toString + "围观"
            biddingCount.text = model.biddingCount.toString + "次出价"
        }
    }
    
    
    class func instance() -> LimitTimeCell {
        let v: LimitTimeCell = Bundle.loadNib("LimitTimeCell")!
        return v
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 8
        layer.shadowColor = C.Color.black.cgColor
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowRadius = 8
        layer.shadowOpacity = 0.12
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.async {
            self.avatar.makeCorner(8, corners: [.topLeft,.topRight])
            let gradient = [C.Color.darkBlack * 0.1, C.Color.darkBlack * 0.8].gradient {
                $0.locations = [0, 1]
                $0.startPoint = CGPoint(x: 0, y: 0.5)
                $0.endPoint = CGPoint(x: 1, y: 0.5)
                $0.frame = self.timeBg.layer.bounds
                return $0
            }
            self.timeBg.layer.insertSublayer(gradient, at: 0)
        }
    }

}
