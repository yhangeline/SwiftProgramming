//
//  ScrollView.swift
//  Precious
//
//  Created by zhubch on 2018/1/14.
//  Copyright © 2018年 zhubch. All rights reserved.
//

import UIKit

class ScrollView: UIScrollView {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        superview?.touchesBegan(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        superview?.touchesEnded(touches, with: event)
    }

}
