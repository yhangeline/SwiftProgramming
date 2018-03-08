//
//  WPUtils.swift
//  WePost
//
//  Created by zhubch on 09/03/2017.
//  Copyright © 2017 happyiterating. All rights reserved.
//

import Foundation
import Contacts
import EZSwiftExtensions

func *(color: UIColor, alpha: CGFloat) -> UIColor {
    return color.withAlphaComponent(alpha)
}

func fetchContacts() -> [CNContact]? {
    let store = CNContactStore()
    let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                       CNContactImageDataKey,
                       CNContactPhoneNumbersKey] as [Any]
    let fetchRequest = CNContactFetchRequest(keysToFetch: keysToFetch as! [CNKeyDescriptor])
    
    var contacts = [CNContact]()
    
    do {
        
        try store.enumerateContacts(with: fetchRequest, usingBlock: { ( contact, stop) -> Void in
            contacts.append(contact)
        })
        
    } catch let error as NSError {
        print(error.localizedDescription) 
        return nil
    } 
    
    return contacts
}

func showMessage(_ msg: String) {
    guard let win = UIApplication.shared.keyWindow else {
        return
    }
    
    var size = msg.sizeWith(maxSize: CGSize(width: C.windowWidth * 0.8, height: 100), font: C.Font.normal.M)
    size.width = size.width + 20
    size.height = size.height + 15
    let msgView = UIView(x:(C.windowWidth - size.width) * 0.5 ,
                         y: (C.windowHeight - size.height) * 0.5,
                         w: size.width,
                         h: size.height)
    msgView.backgroundColor = UIColor(gray: 1, alpha: 0.5)
    msgView.cornerRadius = 4
    let label = UILabel(x: 0, y: 0, w: size.width, h: size.height)
    label.text = msg
    label.textAlignment = .center
    label.textColor = .white
    label.font = C.Font.normal.M
    label.numberOfLines = 0
    win.addSubview(msgView)
    msgView.addSubview(label)
    
    Timer.runThisAfterDelay(seconds: 2) {
        msgView.removeFromSuperview()
    }
}

func showError(_ msg: String) {
    
}


enum PopUpPostion {
    case center
    case bottom
}

struct DismissBlock {
    typealias DismissFunc = ()->Void
    let dismiss: DismissFunc
}

@discardableResult
func popUp(view: UIView, postion: PopUpPostion = .center, dismissAfter: Double = 0) -> DismissBlock {

    let bg = UIView(x: 0, y: 0, w: C.windowWidth, h: C.windowHeight)
    bg.backgroundColor = UIColor(gray: 1, alpha: 0.3)
    bg.addSubview(view)
    
    func dismiss() {
        UIView.animate(withDuration: 0.3, animations: {
            view.y = C.windowHeight
        }) { _ in
            bg.removeFromSuperview()
        }
    }
    
    bg.addTapGesture { _ in
        dismiss()
    }
    
    guard let win = UIApplication.shared.keyWindow else { return DismissBlock(dismiss: dismiss) }
    win.addSubview(bg)
    view.y = C.windowHeight
    view.centerX = bg.centerX
    UIView.animate(withDuration: 0.3) {
        if postion == .center {
            view.centerY = bg.centerY
        } else {
            view.y = bg.h - view.h
        }
    }
    if dismissAfter > 0 {
        Timer.runThisAfterDelay(seconds: dismissAfter) {
            dismiss()
        }
    }

    return DismissBlock(dismiss: dismiss)
}

func popUp<T:UIView>(_ view: T, cancel:((T)->Void)? = nil, done:@escaping (T)->Void) {
    
    view.frame = CGRect(x: 0, y: 40, w: C.windowWidth, h: 260)
    let bg = UIView(x: 0, y: 0, w: C.windowWidth, h: C.windowHeight)
    bg.backgroundColor = UIColor(gray: 1, alpha: 0.3)
    let container = UIView(x: 0, y: C.windowHeight, w: C.windowWidth, h: 300)
    container.backgroundColor = UIColor(hexString: "DEDEDE")
    bg.addSubview(container)
    bg.addTapGesture { _ in
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            container.y = C.windowHeight
        }, completion: { _ in
            bg.removeFromSuperview()
        })
        cancel?(view)
    }
    
    func dismiss() {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            container.y = C.windowHeight
        }) { _ in
            bg.removeFromSuperview()
        }
    }
    
    let toolBar: UIView = {
        let bar = UIView(x: 0, y: 0, w: C.windowWidth, h: 40)
        bar.backgroundColor = C.Color.white
        let cancelBtn = BlockButton(action: { _ in
            dismiss()
            cancel?(view)
        })
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.setTitleColor(C.Color.gold, for: .normal)
        cancelBtn.frame = CGRect(x: 0, y: 0, w: 80, h: 40)
        bar.addSubview(cancelBtn)
        let doneBtn = BlockButton(action: { _ in
            dismiss()
            done(view)
        })
        doneBtn.setTitle("完成", for: .normal)
        doneBtn.setTitleColor(C.Color.gold, for: .normal)
        doneBtn.frame = CGRect(x: C.windowWidth - 80, y: 0, w:  80, h: 40)
        bar.addSubview(doneBtn)
        return bar
    }()

    container.addSubviews([toolBar,view])
    
    guard let win = UIApplication.shared.keyWindow else { return }
    win.addSubview(bg)

    UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
        container.y = C.windowHeight - view.h
    }) { _ in
    }
}

