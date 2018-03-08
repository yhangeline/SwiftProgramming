//
//  ShareView.swift
//  WePost
//
//  Created by Gesen on 2017/4/7.
//  Copyright © 2017年 Happy Iterating Inc. All rights reserved.
//

import Foundation
import MonkeyKing

struct ShareManager {
    
    static let wechatAccount = MonkeyKing.Account.weChat(appID: C.wxAppID, appKey: C.wxAppSecret)
    static let weiboAccount = MonkeyKing.Account.weibo(appID: C.wbAppKey, appKey: C.wbAppSecret, redirectURL: C.wbAppRedirectUrl)
    static let qqAccount = MonkeyKing.Account.qq(appID: C.qqAppID)

    static var weiboAccessToken: String?
    
    static func register() {
        MonkeyKing.registerAccount(wechatAccount)
        MonkeyKing.registerAccount(weiboAccount)
        MonkeyKing.registerAccount(qqAccount)
    }
    
    static func getWeiboAccessToken(completionHandler: @escaping (String?) -> Void) {
        guard !weiboAccount.isAppInstalled, weiboAccessToken == nil else {
            completionHandler(weiboAccessToken)
            return
        }
        
        MonkeyKing.oauth(for: .weibo) { info, response, error in
            
            if let accessToken = info?["access_token"] as? String {
                self.weiboAccessToken = accessToken
            }
            
            completionHandler(self.weiboAccessToken)
            
            print("MonkeyKing.oauth info: \(String(describing: info)), error: \(String(describing: error))")
        }
    }
}

class ShareView: UIView {
    
    weak var vc: UIViewController?
    var share: Share!
    
    @IBAction func tapWechatSession(_ sender: UIButton) {
        let message = MonkeyKing.Message.weChat(.session(info: (
            title: share.title,
            description: share.content,
            thumbnail: share.image,
            media: .url(share.url)
        )))
        
        self.deliver(message: message, sender: sender)
    }
    
    @IBAction func tapWechatTimeline(_ sender: UIButton) {
        let message = MonkeyKing.Message.weChat(.timeline(info: (
            title: share.title,
            description: share.content,
            thumbnail: share.image,
            media: .url(share.url)
        )))
        
        self.deliver(message: message, sender: sender)
    }
    
    @IBAction func tapWeibo(_ sender: UIButton) {
        ShareManager.getWeiboAccessToken { accessToken in
            let message = MonkeyKing.Message.weibo(.default(info: (
                title: self.share.title,
                description: self.share.content,
                thumbnail: self.share.image,
                media: .url(self.share.url)
                ), accessToken: accessToken))
            
            self.deliver(message: message, sender: sender)
        }
    }
    
    @IBAction func tapQQ(_ sender: UIButton) {
        let message = MonkeyKing.Message.qq(.friends(info: (
            title: share.title,
            description: share.content,
            thumbnail: share.image,
            media: .url(share.url)
            )))
        deliver(message: message, sender: sender)
    }
    
    @IBAction func tapQQZone(_ sender: UIButton) {
        
        let message = MonkeyKing.Message.qq(.zone(info: (
            title: share.title,
            description: share.content,
            thumbnail: share.image,
            media: .url(share.url)
        )))
        deliver(message: message, sender: sender)
    }
    private func deliver(message: MonkeyKing.Message, sender: UIButton) {
        sender.isEnabled = false
        
        MonkeyKing.deliver(message) { [weak sender] result in
            sender?.isEnabled = true
            if case .failure = result {
                showMessage("分享失败")
            }
        }
    }
    
}

extension UIViewController {

    func showShare(share: Share) {
        
        guard
            let window = UIApplication.shared.keyWindow,
            window.viewWithTag(1234) == nil,
            window.viewWithTag(1235) == nil else {
            return
        }
        
        let tranformFrom = CGAffineTransform(translationX: 0, y: 168)
        let tranformTo   = CGAffineTransform.identity
        
        let shareView: ShareView = Bundle.loadNib("ShareView")!
            shareView.vc = self
            shareView.tag = 1234
            shareView.share = share
            shareView.frame = CGRect(
                x: 0,
                y: C.windowHeight - 168,
                width: C.windowWidth,
                height: 200
            )
        
        let blackView = UIView()
            blackView.tag = 1235
            blackView.frame = UIScreen.main.bounds
            blackView.backgroundColor = UIColor.black
            blackView.alpha = 0
            blackView.addTapGesture { [unowned self] tap in self.hideShare() }
        
        window.addSubview(blackView)
        window.addSubview(shareView)
        
        blackView.fadeTo(0.4)
        
        shareView.layer.setAffineTransform(tranformFrom)
        shareView.spring(duration: 0.2, animations: {
            shareView.layer.setAffineTransform(tranformTo)
        })
    }

    func hideShare() {
        
        let window = UIApplication.shared.keyWindow
        
        if let shareView = window?.viewWithTag(1234) {
            let tranformFrom = CGAffineTransform(translationX: 0, y: 168)
            
            shareView.spring(animations: {
                shareView.layer.setAffineTransform(tranformFrom)
            }, completion: { _ in
                shareView.removeFromSuperview()
            })
        }
        
        if let blackView = window?.viewWithTag(1235) {
            blackView.fadeOut(completion: { _ in
                blackView.removeFromSuperview()
            })
        }
        
    }

}
