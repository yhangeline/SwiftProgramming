//
//  ProgressView.swift
//  Precious
//
//  Created by zhubch on 2017/12/16.
//  Copyright © 2017年 zhubch. All rights reserved.
//

import UIKit

class ProgressView: UIView {
    
    var progress: CGFloat = 0 {
        didSet {
            indicator.frame = CGRect(x: 0, y: 0, w: w * progress, h: h)
        }
    }
    
    lazy var indicator: UIView = {
        let v = UIView()
        v.cornerRadius = 1
        v.backgroundColor = C.Color.gold
        addSubview(v)
        return v
    }()
    
}
