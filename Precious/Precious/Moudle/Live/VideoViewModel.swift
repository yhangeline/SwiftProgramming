//
//  VideoViewModel.swift
//  Precious
//
//  Created by zhubch on 2018/1/14.
//  Copyright © 2018年 zhubch. All rights reserved.
//

import UIKit

class GeneralMessage: Model {
    struct ImageContent: TextConvertible {
        var string: String {
            return "【图片】"
        }
        var enableTap: Bool {
            return true
        }
        
        var color: UIColor {
            return C.Color.gold
        }
        
        var url: String
    }
    var content: TextConvertible!
    var type: String!
    var user: TextConvertible!
    convenience init(type: String, content: String, user: User?) {
        self.init()
        self.content = type == "image" ? ImageContent(url: content) : NormalText(string: content, color: C.Color.white)
        self.type = type
        self.user = user ?? User.system
    }
}

class VideoViewModel: ViewModel {

    override init() {
        super.init()
        self.modelCellTypes = [
            (GeneralMessage.self,GeneralMessageCell.self)
        ]
    }
    
    func append(_ msg: Message) {
        var section = sections.first ?? [Model]()
        let type = msg.data?["type"].string ?? ""
        let content = msg.data?["content"].string ?? ""
        section.append(GeneralMessage(type: type, content: content, user: msg.user))
        sections = [section]
        listView?.insert(at: IndexPath(row: section.count - 1, section: 0))
    }
    
    override func configureEmptySettings(settings: EmptySettings) {
        super.configureEmptySettings(settings: settings)
        settings.alwaysHidden = true
    }
}
