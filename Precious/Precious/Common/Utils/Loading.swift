//
//  Loading.swift
//  Precious
//
//  Created by zhubch on 2017/12/23.
//  Copyright © 2017年 zhubch. All rights reserved.
//

import UIKit

extension UIViewController {
    func startLoadingAnimation() {
        self.view.startLoadingAnimation()
    }
    
    func stopLoadingAnimation() {
        self.view.stopLoadingAnimation()
    }
}

extension UIView {
    func startLoadingAnimation() {
        stopLoadingAnimation()
        let bg = UIView(frame: bounds)
        bg.tag = 4654
        if self is UIButton {
            bg.backgroundColor = backgroundColor
        } else {
            bg.backgroundColor = UIColor.clear
        }
        let v = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        bg.addSubview(v)
        v.center = bg.center
        v.startAnimating()
        addSubview(bg)
    }
    
    func stopLoadingAnimation() {
        if let v = viewWithTag(4654) {
            v.removeFromSuperview()
        }
    }
}
