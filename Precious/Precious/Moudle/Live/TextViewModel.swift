//
//  TextViewModel.swift
//  Precious
//
//  Created by zhubch on 2018/1/14.
//  Copyright © 2018年 zhubch. All rights reserved.
//

import UIKit

class TextMessage: Model {
    var content: String!
    var user: TextConvertible!
    
    convenience init(content: String, user: User?) {
        self.init()
        self.content = content
        self.user = user ?? User.system
    }
}

class ImageMessage: Model {
    var content: String!
    var user: TextConvertible!
    convenience init(content: String, user: User?) {
        self.init()
        self.content = content
        self.user = user ?? User.system
    }
}

class TextViewModel: ViewModel {
    
    override init() {
        super.init()
        self.modelCellTypes = [
            (ImageMessage.self,ImageMessageCell.self),
            (TextMessage.self,TextMessageCell.self),
        ]
    }
    
    func append(_ msg: Message) {
        var section = sections.first ?? [Model]()
        let type = msg.data?["type"].string ?? ""
        let content = msg.data?["content"].string ?? ""
        
        switch type {
        case "image":
            section.append(ImageMessage(content: content, user: msg.user))
        default:
            section.append(TextMessage(content: content, user: msg.user))
        }
        sections = [section]
        listView?.reload()
    }

    override func configureEmptySettings(settings: EmptySettings) {
        super.configureEmptySettings(settings: settings)
        settings.alwaysHidden = true
    }
}
