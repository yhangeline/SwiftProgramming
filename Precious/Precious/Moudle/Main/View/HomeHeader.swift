//
//  HomeHeader.swift
//  Precious
//
//  Created by zhubch on 2017/12/14.
//  Copyright © 2017年 zhubch. All rights reserved.
//

import UIKit

class HomeHeader: UIView {
    
    @IBOutlet weak var title: UILabel!

    class func instance() -> HomeHeader {
        let header: HomeHeader = Bundle.loadNib("HomeHeader")!
        return header
    }

}
