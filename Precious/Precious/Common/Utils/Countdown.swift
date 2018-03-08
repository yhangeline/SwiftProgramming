//
//  Countdown.swift
//  Precious
//
//  Created by zhubch on 2017/12/12.
//  Copyright © 2017年 zhubch. All rights reserved.
//

import UIKit
import RxSwift

class TimerCenter {
    static let shared = TimerCenter()
    
    var timer: Timer!
    var observers = [Task]()
    
    init() {
        start()
    }
    
    func start() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(count), userInfo: nil, repeats: true)
    }
    
    @objc func count() {
        observers.forEach { $0.trigger() }
    }
}

class Task: NSObject {
    var time: Int
    let ob: AnyObserver<Int>
    
    init(time: Int, ob: AnyObserver<Int>) {
        self.time = time + 1
        self.ob = ob
        super.init()
        self.trigger()
    }
    
    func trigger() {
        time -= 1
        ob.onNext(time)
        if time == 0 {
            ob.onCompleted()
        }
    }
}

func time(from: Int) -> Observable<Int> {
    return  Observable<Int>.create { (ob) -> Disposable in
        let task = Task(time: from, ob: ob)
        TimerCenter.shared.observers.append(task)
        return Disposables.create {
            
        }
    }
}

let UILabelPropertyKey: UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "UILabelPropertyKey".hashValue)
typealias TimeFormatBlock = (Int)->String

extension UILabel {
    
    var disposeBag: DisposeBag {
        if let bag = objc_getAssociatedObject(self, DisposeBagPropertyKey) as? DisposeBag {
            return bag
        }
        let bag = DisposeBag()
        objc_setAssociatedObject(self, DisposeBagPropertyKey, bag, .OBJC_ASSOCIATION_RETAIN)
        return bag
    }
    
    var timeFormatBlock: TimeFormatBlock? {
        get {
            return objc_getAssociatedObject(self, UILabelPropertyKey) as? TimeFormatBlock
        }
        set {
            objc_setAssociatedObject(self, UILabelPropertyKey, newValue, .OBJC_ASSOCIATION_COPY)
        }
    }
    
    func countdown(from: Int) {
        time(from:from).map { "\($0)" }.bind(to: rx.text).disposed(by: disposeBag)
    }
    
}

