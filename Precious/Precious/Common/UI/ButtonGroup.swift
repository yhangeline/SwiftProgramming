//
//  ButtonGroup.swift
//  Precious
//
//  Created by zhubch on 2017/12/23.
//  Copyright © 2017年 zhubch. All rights reserved.
//

import UIKit

class ButtonGroup {
    var selectedIndex: Int {
        didSet {
            buttons.forEachEnumerated { $1.isSelected = $0 == self.selectedIndex }
        }
    }
    
    var selectedChanged: ((_ index: Int)->Void)? // 只有点击按钮才会触发

    private let buttons: [UIButton]
    
    init(buttons: [UIButton], selected: Int = 0) {
        self.buttons = buttons
        selectedIndex = selected
        buttons.forEachEnumerated { (i, btn) in
            btn.tag = i
            btn.isSelected = i == selected
            btn.addTarget(self, action: #selector(self.selectButton(_:)), for: .touchUpInside)
        }
    }
    
    @objc private func selectButton(_ sender: UIButton) {
        if sender.tag == selectedIndex {
            return
        }
        selectedIndex = sender.tag
        selectedChanged?(selectedIndex)
    }
    
}
