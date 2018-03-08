//
//  NumberExtension.swift
//  Precious
//
//  Created by zhubch on 2018/1/13.
//  Copyright © 2018年 zhubch. All rights reserved.
//

import UIKit

extension Double {
    
    var toMoney: String {
        return "￥" + toString
    }
    
    var toShortMoney: String {
        return "￥" + toShort
    }
    
    var toShort: String {
        if self < 10000 {
            return "\(self)"
        }
        var short = String(format: "%.2f", self / 10000)
        while (short.contains(".") && short.hasSuffix("0")) || short.hasSuffix(".") {
            short = short[0 ..< short.length - 1]
        }
        return short + "万"
    }
}

extension Int {
    
    var toMoney: String {
        return "￥" + toString
    }
    
    var toShortMoney: String {
        return "￥" + toShort
    }
    
    var toShort: String {
        if self < 10000 {
            return "\(self)"
        }
        var short = String(format: "%.2f", self.toFloat / 10000)
        while (short.contains(".") && short.hasSuffix("0")) || short.hasSuffix(".") {
            short = short[0 ..< short.length - 1]
        }
        return short + "万"
    }
    
    var time: (Int,Int,Int) {
        let h = self / 3600
        let m = (self % 3600) / 60
        let s = self % 60
        return (h,m,s)
    }
}
