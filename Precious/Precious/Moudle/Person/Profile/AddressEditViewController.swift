//
//  AddressEditViewController.swift
//  Precious
//
//  Created by zhubch on 2017/12/23.
//  Copyright © 2017年 zhubch. All rights reserved.
//

import UIKit

class AddressEditViewController: BaseViewController {
    
    var address: Address!
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var addressDetailField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        if address == nil {
            title = "新增地址"
            address = Address()
        } else {
            title = "修改地址"
        }
        nameField.text = address.userName
        phoneField.text = address.phone
        addressField.text = address.userAdress
        addressDetailField.text = address.userAdress
    }

    @IBAction func save(_ sender: UIButton) {
        address.userName = nameField.text!
        address.phone = phoneField.text!
        address.userAdress = addressDetailField.text!

        sender.startLoadingAnimation()
        let router = address.id.length == 0 ? Router.Address.add(address: address.dict!) : Router.Address.edit(address: address.dict!)
        API.loadJSON(router) { (response) in
            if case .success(let json) = response {
                print(json)
                self.popVC()
            } else if case .failure(let err) = response{
                showMessage(err)
            }
            sender.stopLoadingAnimation()
        }
    }

}
