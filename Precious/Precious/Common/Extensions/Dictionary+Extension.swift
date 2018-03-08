//
//  Dictionary+Extension.swift
//  WePost
//
//  Created by GeSen on 2017/6/6.
//  Copyright © 2017年 Happy Iterating Inc. All rights reserved.
//

import Foundation

func + <K,V>(left: Dictionary<K,V>, right: Dictionary<K,V>) -> Dictionary<K,V> {
    
    var map = Dictionary<K,V>()
    
    for (k, v) in left {
        map[k] = v
    }
    for (k, v) in right {
        map[k] = v
    }
    
    return map
}
