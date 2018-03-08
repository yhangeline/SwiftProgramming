//
//  TextMessageCell.swift
//  Precious
//
//  Created by zhubch on 2018/1/14.
//  Copyright © 2018年 zhubch. All rights reserved.
//

import UIKit

class TextMessageCell: UITableViewCell {
    
    @IBOutlet weak var label: ClickableLabel!
    
    @objc var model: TextMessage! {
        didSet {
            
            label.textArray = [model.user,NormalText(string: model.content, color: C.Color.darkBlack)]
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
