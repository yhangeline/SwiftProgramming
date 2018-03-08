//
//  SimplePickerView.swift
//  Precious
//
//  Created by zhubch on 2018/1/3.
//  Copyright © 2018年 zhubch. All rights reserved.
//

import UIKit

class SimplePickerView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var dataArray: [String] = [] {
        didSet {
            selectedTitle = dataArray.first ?? ""
            selectedIndex = 0
        }
    }
    
    var selectedTitle = ""
    var selectedIndex = 0

    convenience init(dataArray:[String]) {
        self.init(frame: CGRect())
        self.dataArray = dataArray
        self.delegate = self
        self.dataSource = self
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedTitle = dataArray[row]
        selectedIndex = row
    }
}
