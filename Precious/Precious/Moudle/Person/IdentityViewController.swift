//
//  IdentityViewController.swift
//  Precious
//
//  Created by zhubch on 2018/3/7.
//  Copyright © 2018年 zhubch. All rights reserved.
//

import UIKit
import RxSwift

class IdentityViewController: BaseViewController,ImagePicker {
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var numField: UITextField!

    var buttonGroup: ButtonGroup!
    
    var type = 1
    let reverseSide = Variable("")
    let rightSide = Variable("")
    var sender: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "实名认证"
        buttonGroup = ButtonGroup(buttons: [button1,button2])
        buttonGroup.selectedChanged = {
            self.type = $0 + 1
        }
        
        let ob1 = Observable.combineLatest(nameField.rx.text, numField.rx.text) { ($0 ?? "").length > 0 && ($1 ?? "").length > 0 }
        let ob2 = Observable.combineLatest(reverseSide.asObservable(), rightSide.asObservable()) { $0.length > 0 && $1.length > 0 }
        let ob = Observable.combineLatest(ob1, ob2) { $0 && $1 }
        
        ob.bind(to: submitButton.rx.isEnabled).disposed(by: disposeBag)
    }

    override func navigationBarDidLoad() {
        super.navigationBarDidLoad()
        navigationBar.rightButtonConfigure1 = NavButtonConfigure(darkImage: #imageLiteral(resourceName: "icon_common_help"), lightImage: #imageLiteral(resourceName: "icon_common_help"), handler: { _ in
        })
    }
    
    @IBAction func chooseImage(_ sender: UIButton) {
        self.sender = sender
        pickImage()
    }

    @IBAction func submit(_ sender: UIButton) {
        sender.startLoadingAnimation()
        let info = [
            "idNo": numField.text!,
            "idReverseSide": reverseSide.value,
            "idRightSide": rightSide.value,
            "idType": type,
            "realName": nameField.text!
            ] as [String : Any]
        API.loadJSON(Router.User.identity(info: info)) { (response) in
            if case .success(let json) = response {
                print(json)
                showMessage("资料上传成功，请等待审核")
                self.popVC()
            } else if case .failure(let msg) = response {
                showMessage(msg)
            }
            sender.stopLoadingAnimation()
        }
    }
    
    func didPickImage(_ image: UIImage) {
        sender.startLoadingAnimation()
        API.uploadImage(image) { (response) in
            if case .success(let urls) = response {
                guard let url = urls.first else { return }
                self.sender.setImage(url: url)
                self.sender.imageEdgeInsets = UIEdgeInsets()
                if self.sender.tag == 0 {
                    self.rightSide.value = url
                } else {
                    self.reverseSide.value = url
                }
            }
            self.sender.stopLoadingAnimation()
        }
    }
}
