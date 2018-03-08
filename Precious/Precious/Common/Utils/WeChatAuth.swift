//
//  WeChatAuthManager.swift
//  WePost
//
//  Created by zhubch on 2017/4/11.
//  Copyright © 2017年 Happy Iterating Inc. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

enum ErrorType {
    case token
    case userInfo
}

class WeChatAuthError: Error {
    
    var errorType:ErrorType!
    
    var localizedDescription: String! {
        if self.errorType == .token {
            return "获取token失败"
        }
        return "获取用户信息失败"
    }
    
    init(errorType: ErrorType) {
        self.errorType = errorType
    }
}

func wxAuth(completionHandler: @escaping (Result<[String : Any]>) -> Void){
    let req = SendAuthReq()
    req.scope = "snsapi_userinfo"
    req.state = "org.wepost.wechatlogin"
    WXApi.send(req)
    
    var ob: Any? = nil
    ob = WeChatCompleted.observe { (resp) in
        if resp.errCode == 0 {
            API.loadJSON(Router.User.wxLogin(code: resp.code), completionHandler: { (response) in
                if case .success(let json) = response {
                    print(json)
                }
            })
        }
        if ob != nil {
            WeChatCompleted.removeObserver(ob!)
        }
    }
}

func fetchUserInfo(dic:JSON,completionHandler: @escaping (Result<[String : Any]>) -> Void){
    guard dic["access_token"].string != nil else {
        let error = WeChatAuthError(errorType: .token)
        completionHandler(.failure(error))
        return
    }
    
    let urlString = String.init(format: C.URL.wxUserInfo, dic["access_token"].string!,dic["openid"].string!,"zh_CN")
    request(urlString).responseJSON { (response) in
        
        let userInfo = JSON(response.value!)
        
        guard let _ = userInfo["unionid"].string else {
            let error = WeChatAuthError(errorType: .userInfo)
            completionHandler(.failure(error))
            return
        }
        
        let info: [String:Any] =
            [
                "access_token": dic["access_token"].string!,
                "expires_in": dic["expires_in"].int!,
                "refresh_token": "string",
                "site_user_avatar_url": userInfo["headimgurl"].string!,
                "site_user_bio": "string",
                "site_user_email": "string",
                "site_user_location": "string",
                "site_user_name": userInfo["nickname"].string!,
                "site_user_uid": userInfo["unionid"].string!,
                "wechat_open_id":userInfo["openid"].string!]
        print("\(userInfo)")
        completionHandler(.success(info))
    }
}
