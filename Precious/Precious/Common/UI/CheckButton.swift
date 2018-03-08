//
//  CheckButton.swift
//  Precious
//
//  Created by zhubch on 2018/1/7.
//  Copyright © 2018年 zhubch. All rights reserved.
//

import UIKit
import RxSwift

class CheckButton: UIButton {
    
    let checked = Variable(false)
    
    let bag = DisposeBag()
    
    @objc func toggle() {
        checked.value = checked.value.toggled
        isSelected = checked.value
    }
    
    func setup() {
        addTarget(self, action: #selector(toggle), for: .touchUpInside)
        isSelected = checked.value
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
}
