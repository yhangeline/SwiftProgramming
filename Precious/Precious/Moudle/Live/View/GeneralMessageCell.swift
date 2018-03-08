//
//  GeneralMessageCell.swift
//  Precious
//
//  Created by zhubch on 2018/1/14.
//  Copyright © 2018年 zhubch. All rights reserved.
//

import UIKit

class GeneralMessageCell: UITableViewCell {
    
    @IBOutlet weak var label: ClickableLabel!
    
    @objc var model: GeneralMessage! {
        didSet {
            label.textArray = [model.user,model.content]
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
