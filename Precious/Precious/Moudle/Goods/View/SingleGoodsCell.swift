//
//  SingleGoodsCell.swift
//  Precious
//
//  Created by zhubch on 2017/12/16.
//  Copyright © 2017年 zhubch. All rights reserved.
//

import UIKit

class SingleGoodsCell: UITableViewCell, UIScrollViewDelegate {
    
    @IBOutlet weak var avatar1: UIImageView!
    @IBOutlet weak var avatar2: UIImageView!
    @IBOutlet weak var avatar3: UIImageView!
    @IBOutlet weak var avatar4: UIImageView!
    @IBOutlet weak var avatar5: UIImageView!
    @IBOutlet weak var likeCount: UILabel!
    @IBOutlet weak var goodName: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var progressView: ProgressView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @objc var model: Goods! {
        didSet {
            avatar1.setImageWith(url: "https://avatars1.githubusercontent.com/u/12390784?s=400&v=4")
            avatar2.setImageWith(url: "https://avatars1.githubusercontent.com/u/12390784?s=400&v=4")
            avatar3.setImageWith(url: "https://avatars1.githubusercontent.com/u/12390784?s=400&v=4")
            avatar4.setImageWith(url: "https://avatars1.githubusercontent.com/u/12390784?s=400&v=4")
            avatar5.setImageWith(url: "https://avatars1.githubusercontent.com/u/12390784?s=400&v=4")

            goodName.text = model.name
            likeCount.text = "\(model.agreeCount)人点赞"
            let w = C.windowWidth - 32
            let h = w * 214 / 343

            if model.imageList.count == 0 {
                model.imageList.append("")
            }
            for i in 0..<model.imageList.count {
                let imgView = UIImageView(frame: CGRect(x: i.toCGFloat * w, y: 0, w: w, h: h))
                imgView.setImageWith(url: model.imageList[i])
                scrollView.addSubview(imgView)
            }
            scrollView.contentSize = CGSize(width: model.imageList.count.toCGFloat * w, height: 0)
            scrollView.delegate = self
            progressView.progress = (scrollView.contentOffset.x + C.windowWidth - 32)  / scrollView.contentSize.width
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        progressView.progress = (scrollView.contentOffset.x + C.windowWidth - 32)  / scrollView.contentSize.width
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
