//
//  AddressCell.swift
//  Precious
//
//  Created by zhubch on 2017/12/23.
//  Copyright © 2017年 zhubch. All rights reserved.
//

import UIKit
import RxSwift

protocol AddressOperator: NSObjectProtocol {
    func deleteAddress(_ model: Address)
    func editAddress(_ model: Address)
    func checkAddress(_ model: Address)
}

class AddressCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var defaultButton: UIButton!
    
    weak var delegate: AddressOperator?

    @objc var model: Address! {
        didSet {
            name.text = model.userName
            phone.text = model.phone
            address.text = model.readableAddress
            defaultButton.isSelected = model.isDefault == "1"
        }
    }
    
    @IBAction func editAddress(_ sender: Any) {
        delegate?.editAddress(model)
    }
    
    @IBAction func deleteAddress(_ sender: Any) {
        delegate?.deleteAddress(model)
    }
    
    @IBAction func checkAddress(_ sender: UIButton) {
        sender.isSelected = sender.isSelected.toggled
        delegate?.checkAddress(model)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
