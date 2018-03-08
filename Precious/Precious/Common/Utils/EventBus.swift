//
//  WPEventBus.swift
//  WePost
//
//  Created by zhubch on 14/03/2017.
//  Copyright © 2017 happyiterating. All rights reserved.
//

import UIKit

fileprivate let infoKey = "EventBusInfoKey"

public protocol EventBus {
    associatedtype InfoType
    static var name: Notification.Name { get }
    static func observe(eventBlock: @escaping (InfoType) -> ()) -> Any
    static func post(info: InfoType?)
}

extension EventBus {
    
    @discardableResult static func observe(eventBlock: @escaping (InfoType) -> ()) -> Any {
        return NotificationCenter.default.addObserver(forName: name, object: nil, queue: .main) { notification in
            if let userInfo = notification.userInfo {
                eventBlock((userInfo[infoKey] as? InfoType)!)
            }
        }
    }
    
    static func removeObserver(_ ob: Any) {
        NotificationCenter.default.removeObserver(ob)
    }
    
    static func post(info: InfoType? = nil) {
        let userInfo: [AnyHashable : Any] = [infoKey : info ?? ""]
        NotificationCenter.default.post(name: name, object: nil, userInfo: userInfo)
    }
}

class WeChatCompleted: EventBus {
    typealias InfoType = SendAuthResp
    static var name = Notification.Name("WeChatCompleted")
}

