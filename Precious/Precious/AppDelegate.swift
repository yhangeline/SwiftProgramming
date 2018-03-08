//
//  AppDelegate.swift
//  Precious
//
//  Created by zhubch on 2017/11/29.
//  Copyright © 2017年 zhubch. All rights reserved.
//

import UIKit
import SwipeBack

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UserDefaults.standard.register(defaults: ["hasShowGuide":false])
        if UserDefaults.standard.bool(forKey: "hasShowGuide") {
            window?.rootViewController = C.Storyboard.Main.entry
        } else {
            window?.rootViewController = C.Storyboard.Guide.entry
            UserDefaults.standard.set(true, forKey: "hasShowGuide")
        }

        WXApi.registerApp(C.wxAppID)
        URLNavigation.register()
        ShareManager.register()
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return WXApi.handleOpen(url, delegate: self) || true
    }

}

extension AppDelegate: WXApiDelegate {
    func onReq(_ req: BaseReq!) {
        
    }
    
    func onResp(_ resp: BaseResp!) {
        if let authResp = resp as? SendAuthResp {
            WeChatCompleted.post(info: authResp)
        } else {
            
        }
    }
}

