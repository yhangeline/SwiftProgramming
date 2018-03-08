//
//  AuctionCell.swift
//  Precious
//
//  Created by zhubch on 2017/12/13.
//  Copyright © 2017年 zhubch. All rights reserved.
//

import UIKit

class AuctionCell: UITableViewCell {
    
    @objc var model: Auction! {
        didSet {
            avatar.setImageWith(url:model.image)
            salesName.text = model.salesName
            userName.text = model.userName
            looksCount.text = model.looksCount.toString
            biddingCount.text = model.biddingCount.toString
            liveIcon.isHidden = model._status != .selling
            timeIcon.isHidden = model._status != .toSell
            time.isHidden = model._status != .toSell
            statusIcon.image = model._status.icon
            status.text = model._status.string
            time.text = (model.startTime?.toDate?.readableString() ?? "--") + " 开拍"

            let h = (C.windowWidth - 45) * 88 / 330

            for i in 0..<model.goodsList.count {
                let imgView = UIImageView(frame: CGRect(x: i.toCGFloat * (h + 4), y: 0, w: h, h: h))
                imgView.setImageWith(url: model.goodsList[i].image)
                imgView.backgroundColor = C.Color.lightGray
                imgView.cornerRadius = 4
                scrollView.addSubview(imgView)
            }
            scrollView.contentSize = CGSize(width: model.goodsList.count.toCGFloat * (h + 4), height: 0)
        }
    }
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var salesName: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var looksCount: UILabel!
    @IBOutlet weak var biddingCount: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var liveIcon: UIImageView!
    @IBOutlet weak var statusIcon: UIImageView!
    @IBOutlet weak var timeIcon: UIImageView!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var container: UIView!


    override func awakeFromNib() {
        super.awakeFromNib()
        
        container.layer.cornerRadius = 8
        container.layer.shadowColor = C.Color.black.cgColor
        container.layer.shadowOffset = CGSize(width: 1, height: 1)
        container.layer.shadowRadius = 8
        container.layer.shadowOpacity = 0.12
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.async {
            self.avatar.makeCorner(8, corners: [.topLeft,.topRight])
        }
    }
    
}
