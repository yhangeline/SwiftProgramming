//
//  UIViewController+RX.swift
//  Precious
//
//  Created by zhubch on 2017/12/12.
//  Copyright © 2017年 zhubch. All rights reserved.
//

import UIKit
import RxSwift

let DisposeBagPropertyKey: UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "DisposeBagPropertyKey".hashValue)

extension UIViewController {
    var disposeBag: DisposeBag {
        if let bag = objc_getAssociatedObject(self, DisposeBagPropertyKey) as? DisposeBag {
            return bag
        }
        let bag = DisposeBag()
        objc_setAssociatedObject(self, DisposeBagPropertyKey, bag, .OBJC_ASSOCIATION_RETAIN)
        return bag
    }
}
