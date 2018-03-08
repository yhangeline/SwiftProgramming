//
//  GuideViewController.swift
//  Precious
//
//  Created by zhubch on 2018/3/7.
//  Copyright © 2018年 zhubch. All rights reserved.
//

import UIKit

class GuideViewController: UIViewController {
    
    let scrollView = UIScrollView(x: 0, y: 0, w: C.windowWidth, h: C.windowHeight)

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(scrollView)
        
        for i in 0..<5 {
            let imgView = UIImageView(x: i.toCGFloat * C.windowWidth, y: 0, w: C.windowWidth, h: C.windowHeight, image: UIImage(named: "guide_\(i+1)")!)
            scrollView.addSubview(imgView)
            if i == 4 {
                imgView.addTapGesture(action: { _ in
                    let vc = C.Storyboard.Login.entry!
                    vc.modalTransitionStyle = .partialCurl
                    self.presentVC(vc)
                })
            }
        }
        scrollView.contentSize = CGSize(width: 5 * C.windowWidth, height: C.windowHeight)
        scrollView.isPagingEnabled = true
    }

}
