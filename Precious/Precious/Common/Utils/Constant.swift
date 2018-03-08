//
//  WPConstant.swift
//  WePost
//
//  Created by zhubch on 13/03/2017.
//  Copyright © 2017 happyiterating. All rights reserved.
//

import UIKit

struct C {
    
    struct URL {
        static let about = "https://www.wepost.org/about"
        static let terms = "https://www.wepost.org/terms"
        static let wxUserInfo = "https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@&lang=%@"
        static let wxAuth = "https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code"
    }
    
    struct Color {
        static let white = UIColor.white
        static let gray = UIColor(hexString: "999999")!
        static let lightGray = UIColor(hexString: "ededed")!
        static let gold = UIColor(hexString: "C79E62")!
        static let black = UIColor(hexString: "333333")!
        static let darkGray = UIColor(hexString: "363636")!
        static let background = UIColor(r: 242, g: 241, b: 240)
        static let yellow = UIColor(hexString: "F3BB2C")!
        static let darkBlack = UIColor(hexString: "151515")!
    }
    
    struct Font {
        
        static let medium = FontMaker(fontName: "PingFangSC-Medium")
        static let normal = FontMaker(fontName: "PingFangSC-Regular")
    }
    
    enum Storyboard: String {
        case Main
        case Auction
        case Goods
        case User
        case Live
        case Login
        case Store
        case Guide

        public func instantiateVC<T>(_ identifier: T.Type) -> T? {
            return UIStoryboard(name: self.rawValue, bundle: nil).instantiateVC(T.self)
        }
        
        var entry: UIViewController? {
            return UIStoryboard(name: self.rawValue, bundle: nil).instantiateInitialViewController()
        }
    }

    static let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!

    static let wxAppID = "wx1d79a08e06dc51e5"
    static let wxAppSecret = "fb8e72b9a97cd2ef853cb948732a85ee"
    
    static let qqAppID = "1106672073"
    static let qqAppSecret = "FIZ49sgd0QSjZjKO"
    
    static let wbAppKey = "3911190162"
    static let wbAppSecret = "dcd868e1df6e512bc619ea4a7069253e"
    static let wbAppRedirectUrl = "https://api.weibo.com/oauth2/default.html"
    
    static let jpushAppKey = "ad39f87682f6a9027ced850d"

    static let windowWidth = UIScreen.main.bounds.width
    static let windowHeight = UIScreen.main.bounds.height
    static let statusBarHeight = UIApplication.shared.statusBarFrame.height
}

struct FontMaker {
    let fontName: String
    
    func size(_ size: CGFloat) -> UIFont {
        return UIFont(name: fontName, size: size)!
    }
    
    var XXL: UIFont {
        return size(24)
    }
    
    var XL: UIFont {
        return size(20)
    }
    
    var L: UIFont {
        return size(18)
    }
    
    var M: UIFont {
        return size(16)
    }
    
    var S: UIFont {
        return size(14)
    }
    
    var SS: UIFont {
        return size(12)
    }
    
}


