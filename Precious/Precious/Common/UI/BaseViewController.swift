//
//  BaseViewController.swift
//  Precious
//
//  Created by zhubch on 2017/12/17.
//  Copyright © 2017年 zhubch. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class NavButtonConfigure {
    var darkImage: UIImage?
    var lightImage: UIImage?
    var title: String?
    var handler: ((UIButton)->Void)!
    
    convenience init(darkImage: UIImage, lightImage: UIImage, handler: @escaping ((UIButton)->Void)) {
        self.init()
        self.darkImage = darkImage
        self.lightImage = lightImage
        self.handler = handler
    }
    
    convenience init(title: String, handler: @escaping ((UIButton)->Void)) {
        self.init()
        self.title = title
        self.handler = handler
    }
}

class NavigationBar: UIView {
    fileprivate let titleLabel = UILabel(font: C.Font.medium.XXL, color: C.Color.white, alignment: .center)
    
    fileprivate let lightBackButton = BlockButton()
    fileprivate let darkBackButton = BlockButton()
    
    fileprivate let lightRightButton1 = BlockButton()
    fileprivate let darkRightButton1 = BlockButton()

    fileprivate let lightRightButton2 = BlockButton()
    fileprivate let darkRightButton2 = BlockButton()
    
    fileprivate let backgroundView = UIView()
    
    var translucentChanged: (()->Void)?
    
    var rightButtonConfigure1: NavButtonConfigure? {
        didSet {
            darkRightButton1.setImage(rightButtonConfigure1?.darkImage, for: .normal)
            lightRightButton1.setImage(rightButtonConfigure1?.lightImage, for: .normal)
            darkRightButton1.setTitle(rightButtonConfigure1?.title, for: .normal)
            lightRightButton1.setTitle(rightButtonConfigure1?.title, for: .normal)
            if let handler = rightButtonConfigure1?.handler {
                darkRightButton1.addAction(handler)
                lightRightButton1.addAction(handler)
            }
        }
    }
    
    var rightButtonConfigure2: NavButtonConfigure? {
        didSet {
            darkRightButton2.setImage(rightButtonConfigure2?.darkImage, for: .normal)
            lightRightButton2.setImage(rightButtonConfigure2?.lightImage, for: .normal)
            darkRightButton2.setTitle(rightButtonConfigure2?.title, for: .normal)
            lightRightButton2.setTitle(rightButtonConfigure2?.title, for: .normal)
            if let handler = rightButtonConfigure2?.handler {
                darkRightButton2.addAction(handler)
                lightRightButton2.addAction(handler)
            }
        }
    }
    
    var isTranslucent: Bool {
        return alpha < 0.1
    }
    
    override var alpha: CGFloat {
        get {
            return backgroundView.alpha
        }
        
        set {
            backgroundView.alpha = newValue
            backgroundView.isHidden = newValue < 0.1
            
            if newValue < 0.1 || newValue > 0.9 {
                translucentChanged?()
            }
        }
    }

    convenience init(title: String?) {
        self.init(frame: CGRect(x: 0, y: 0, w: C.windowWidth, h: 44 + C.statusBarHeight))
        backgroundColor = .clear

        backgroundView.backgroundColor = .white
        backgroundView.addSubviews([titleLabel,darkBackButton,darkRightButton1,darkRightButton2])
        
        addSubviews([lightBackButton,lightRightButton1,lightRightButton2,backgroundView])
        titleLabel.text = title
        titleLabel.textColor = C.Color.black
        titleLabel.font = C.Font.medium.XL

        lightBackButton.setImage(#imageLiteral(resourceName: "icon_common_nav_back"), for: .normal)
        darkBackButton.setImage(#imageLiteral(resourceName: "icon_common_nav_back_b"), for: .normal)
        
        lightRightButton1.setTitleColor(C.Color.white, for: .normal)
        lightRightButton2.setTitleColor(C.Color.white, for: .normal)
        
        darkRightButton1.setTitleColor(C.Color.black, for: .normal)
        darkRightButton2.setTitleColor(C.Color.black, for: .normal)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.frame = CGRect(x: 50, y: C.statusBarHeight, w: C.windowWidth - 100, h: 44)
        backgroundView.frame = self.bounds
        
        var frame = CGRect(x: 8, y: C.statusBarHeight, w: 44, h: 44)
        darkBackButton.frame = frame
        lightBackButton.frame = frame
        
        frame = CGRect(x: C.windowWidth - 8 - 44, y: C.statusBarHeight, w: 44, h: 44)
        darkRightButton1.frame = frame
        lightRightButton1.frame = frame
        
        frame = CGRect(x: C.windowWidth - (8 + 44) * 2, y: C.statusBarHeight, w: 44, h: 44)
        darkRightButton2.frame = frame
        lightRightButton2.frame = frame
        
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if !isUserInteractionEnabled || isHidden {
            return nil
        }
        if !self.point(inside: point, with: event) {
            return nil
        }
        for v in subviews.reversed() {
            let p = self.convert(point, to: v)
            if let fitView = v.hitTest(p, with: event) {
                return fitView
            }
        }
        return self
    }
}

class BaseViewController: UIViewController {
    
    public let navigationBar = NavigationBar(title: "")
    
    open var shouldBack: Bool {
        return true
    }
    
    open var showNavigationBar: Bool {
        return (self.navigationController?.viewControllers.count ?? 0) > 1
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if showNavigationBar && navigationBar.isTranslucent {
            return .lightContent
        }
        return .default
    }
    
    override var title: String? {
        didSet {
            navigationBar.titleLabel.text = title
        }
    }
    
    @IBAction func back() {
        if shouldBack {
            popVC()
        }
    }
    
    private func loadNavBar() {
        navigationBar.darkBackButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        navigationBar.lightBackButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        navigationBar.isHidden = false
        view.addSubview(navigationBar)
        navigationBarDidLoad()
        setNeedsStatusBarAppearanceUpdate()
        navigationBar.translucentChanged = { self.setNeedsStatusBarAppearanceUpdate() }
    }
    
    open func navigationBarDidLoad() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if showNavigationBar {
            loadNavBar()
        }
    }
    
    deinit {
        print("deinit: " + String(describing: className))
    }
}
