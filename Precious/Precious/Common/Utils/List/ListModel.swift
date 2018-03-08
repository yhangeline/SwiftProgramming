//
//  ListModel.swift
//  
//
//  Created by zhubch on 2017/7/3.
//  Copyright © 2017年 . All rights reserved.
//

import UIKit

protocol ListModel {
    
    static var cellIdentifier: String { get }
}

extension ListModel {
    
    static var cellIdentifier: String {
        return String(describing: self)
    }
}
