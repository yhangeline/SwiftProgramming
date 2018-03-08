//
//  ImageMessageCell.swift
//  Precious
//
//  Created by zhubch on 2018/1/14.
//  Copyright © 2018年 zhubch. All rights reserved.
//

import UIKit

class ImageMessageCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var imgWidth: NSLayoutConstraint!
    @IBOutlet weak var imgHeight: NSLayoutConstraint!
    @IBOutlet weak var label: ClickableLabel!

    @objc var model: ImageMessage! {
        didSet {
            label.textArray = [model.user]
            let maxW = C.windowWidth - 200
            let maxh = C.windowHeight - 200
            imgView.setImageWith(url: model.content, placeholder: nil) { (image) in
                if var image = image {
                    if image.size.width > maxW || image.size.height > maxh {
                        image = image.resize(CGSize(width: maxW, height: maxh), option: .scaleAspectFill)!
                    }
                    self.imgView.image = image
                    self.imgWidth.constant = image.size.width
                    self.imgHeight.constant = image.size.height
                    self.layoutIfNeeded()
                }
            }
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
