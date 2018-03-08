//
//  BannerView.swift
//  Precious
//
//  Created by zhubch on 2017/12/15.
//  Copyright © 2017年 zhubch. All rights reserved.
//

import UIKit

class BannerView: UIView, UIScrollViewDelegate {
    
    let scrollView = UIScrollView()
    
    let leftImageView = UIImageView()
    let middleImageView = UIImageView()
    let rightImageView = UIImageView()
    
    var images: [String]? {
        didSet {
            current = 0
        }
    }
    
    var current = 0 {
        didSet {
            guard let images = images else { return }
            if current < 0 {
                current = current + images.count
            }
            if current == images.count {
                current = current - images.count
            }
            let left = current == 0 ? images.count - 1 : current - 1
            let right = current == images.count - 1 ? 0 : current + 1
            leftImageView.imageURL = images[left]
            middleImageView.imageURL = images[current]
            rightImageView.imageURL = images[right]
            scrollView.contentOffset = CGPoint(x:self.scrollView.bounds.width,y:0)
        }
    }
    
    func transform() {
        let imgViews = [leftImageView,middleImageView,rightImageView]
        for i in 0..<3 {
            let offset = scrollView.bounds.width * CGFloat(i)  - scrollView.contentOffset.x
            let translate = -48 * (offset/w)
            let scaleX = 10 * (fabs(offset)/w) + 24
            let scaleY = 10 * (fabs(offset)/w)
            imgViews[i].frame = CGRect(x: w * i.toCGFloat + scaleX + translate, y: 0 + scaleY, width: w - scaleX * 2, height: scrollView.bounds.height - scaleY * 2)
            imgViews[i].cornerRadius = 8
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.frame = bounds
        scrollView.delegate = self
        current = 0
        addSubview(scrollView)
        scrollView.addSubviews([leftImageView,middleImageView,rightImageView])
        scrollView.contentSize = CGSize(width: scrollView.bounds.width * 3, height: 0)
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        transform()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        current = current + Int((scrollView.contentOffset.x - scrollView.bounds.width) / scrollView.bounds.width)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        transform()
    }
}
