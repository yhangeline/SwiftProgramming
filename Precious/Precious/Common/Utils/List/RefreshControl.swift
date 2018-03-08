//
//  RefreshControl.swift
//  WePost
//
//  Created by GeSen on 2017/5/25.
//  Copyright © 2017年 happyiterating. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RefreshControl: UIControl {
    
    static var defaultControl: RefreshControl {
        let refreshControl = RefreshControl()
        refreshControl.frame = CGRect(x: 0,
                                      y: -refreshControl.refreshHeight,
                                      w: C.windowWidth,
                                      h: refreshControl.refreshHeight)
        return refreshControl
    }
    
    enum RefreshState {
        case normal
        case pulling
        case refreshing
    }
    
    weak var scrollView: UIScrollView? {
        didSet { setupScrollView() }
    }
    
    let loadingView = UIImageView(image: #imageLiteral(resourceName: "aa_logo"))
    
    var refreshState: RefreshState = .normal {
        didSet {
            if refreshState == .refreshing {
                scrollView?.allInsetTop = self.refreshHeight
                addRotation()
                sendActions(for: .valueChanged)
            }
        }
    }
    
    var refreshHeight: CGFloat = 50
    
    init() {
        super.init(frame: CGRect.zero)
        loadingView.frame = CGRect(origin: CGPoint.zero,
                                   size: CGSize(width: 30, height: 30))
        addSubview(loadingView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        loadingView.center = bounds.center
    }
    
    func beginRefreshing() {
        guard let tableView = scrollView else { return }
        
        if refreshState != .refreshing {
            refreshState = .refreshing
            tableView.scrollRectToVisible(tableView.bounds.offsetBy(dx: 0, dy: -1), animated: true)
        }
    }
    
    func endRefreshing() {
        guard let scrollView = scrollView else { return }
        
        if refreshState == .refreshing {
            refreshState = .normal
            UIView.animate(withDuration: 0.3,
                animations: { scrollView.allInsetTop = 0 }
            )
            removeRotation()
        }
    }
    
    private func setupScrollView() {
        
        _ = scrollView?.rx
            .didScroll
            .takeUntil(scrollView!.rx.deallocated)
            .subscribe(onNext: { [weak self] event in
                guard
                    let this = self,
                    let tableView = this.scrollView,
                    this.refreshState != .refreshing,
                    tableView.contentOffset.y < 0 else { return }
                
                this.setRotation(fraction: -tableView.contentOffset.y / this.refreshHeight)
                this.refreshState = tableView.contentOffset.y < -this.refreshHeight ? .pulling : .normal
            })
        
        _ = scrollView?.rx
            .didEndDragging
            .takeUntil(scrollView!.rx.deallocated)
            .subscribe(onNext: { [weak self] event in
                guard
                    let this = self,
                    this.refreshState == .pulling else { return }
                
                this.refreshState = .refreshing
            })
        
    }
    
    private func setRotation(fraction: CGFloat) {
        loadingView.layer.transform = CATransform3DMakeRotation(fraction * CGFloat.pi * 2, 0.0, 0.0, 1.0);
    }
    
    private func addRotation() {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.fromValue = 0.0
        rotationAnimation.toValue = 2 * CGFloat.pi
        rotationAnimation.duration = 0.5
        rotationAnimation.repeatCount = 100
        loadingView.layer.add(rotationAnimation, forKey: "rotation")
    }
    
    private func removeRotation() {
        loadingView.layer.removeAnimation(forKey: "rotation")
    }

}
