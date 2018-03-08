//
//  TextField.swift
//  Precious
//
//  Created by zhubch on 2017/12/12.
//  Copyright © 2017年 zhubch. All rights reserved.
//

import UIKit
import RxSwift

class TextField: UITextField {

    @IBInspectable var maxLength: Int = 0
    @IBInspectable var normalColor: UIColor = C.Color.white * 0.3
    @IBInspectable var selectedColor: UIColor = C.Color.white * 0.8

    let bag = DisposeBag()
    
    var didDeleteBackward: ((TextField)->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bottomLine.image = #imageLiteral(resourceName: "img_login_line")
        addSubview(bottomLine)
        borderStyle = .none
        textColor = normalColor
        placeholderLabel?.textColor = textColor
        placeholderLabel?.font = font
        leftSpace = 10
        
        guard maxLength > 0 else {
            return
        }

        self.rx.text.map{ $0 ?? "" }.subscribe(onNext: { [unowned self](string) in
            if string.length > self.maxLength {
                self.text = string[0..<self.maxLength]
            }
        }).disposed(by: bag)
        didDeleteBackward = nil
    }
    
    let bottomLine = UIImageView()
    
    @discardableResult
    override func becomeFirstResponder() -> Bool {
        bottomLine.image = #imageLiteral(resourceName: "img_login_line_s")
        textColor = selectedColor
        return super.becomeFirstResponder()
    }
    
    @discardableResult
    override func resignFirstResponder() -> Bool {
        bottomLine.image = #imageLiteral(resourceName: "img_login_line")
        textColor = normalColor
        return super.resignFirstResponder()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bottomLine.frame = CGRect(x: 0, y: bounds.height - 6, w: bounds.width, h: 6)
    }
    
    override func deleteBackward() {
        super.deleteBackward()

        didDeleteBackward?(self)
    }

}
