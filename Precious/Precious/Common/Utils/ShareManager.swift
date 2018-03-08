//
//  WPShareManager.swift
//  WePost
//
//  Created by Gesen on 2017/4/25.
//  Copyright © 2017年 Happy Iterating Inc. All rights reserved.
//

import Foundation
import MonkeyKing

struct ShareManager {
    
    static let wechatAccount = MonkeyKing.Account.weChat(appID: WPConstant.wxAppID, appKey: WPConstant.wxAppSecret)
    static let weiboAccount = MonkeyKing.Account.weibo(appID: WPConstant.wbAppKey, appKey: WPConstant.wbAppSecret, redirectURL: WPConstant.wbAppRedirectUrl)
    static var weiboAccessToken: String?
    
    static func register() {
        MonkeyKing.registerAccount(wechatAccount)
        MonkeyKing.registerAccount(weiboAccount)
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
