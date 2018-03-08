//
//  Date+Extension.swift
//  WePost
//
//  Created by GeSen on 2017/6/6.
//  Copyright © 2017年 Happy Iterating Inc. All rights reserved.
//

import Foundation

extension String {
    var toDate: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.date(from: self)
    }
}


extension Date {
    var formatDate: String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: self)
    }
    
    var leftTime: String? {
        let interval = self.timeIntervalSince(Date())
        let time = interval.toInt.time
        var ret = ""
        if time.0 > 0 {
            ret += "\(time.0)小时 "
        }
        ret += "\(time.1)分钟"
        return ret
    }
    
    var dateComponents: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy年M月d日"
        let str = dateFormatter.string(from: self)
        dateFormatter.dateFormat = "yyyy年M月d日"
        
        return dateFormatter.date(from: str)!
    }
    
    public func readableString() -> String {
        let calendar = Calendar.current
        
        if calendar.isDateInTomorrow(self) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "明天 HH:mm"
            return dateFormatter.string(from: self)
        }
        
        if calendar.isDateInToday(self) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "今天 HH:mm"
            return dateFormatter.string(from: self)
        }
        
        if calendar.isDateInYesterday(self) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "昨天 HH:mm"
            return dateFormatter.string(from: self)
        }
        
        if calendar.compare(Date(), to: self, toGranularity: .year) == .orderedSame {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "M月d日 HH:mm"
            return dateFormatter.string(from: self)
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy年M月d日 HH:mm"
        return dateFormatter.string(from: self)
    }
    
}
