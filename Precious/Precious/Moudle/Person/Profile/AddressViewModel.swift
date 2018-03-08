//
//  AddressViewModel.swift
//  Precious
//
//  Created by zhubch on 2018/1/23.
//  Copyright © 2018年 zhubch. All rights reserved.
//

import UIKit

class AddressViewModel: ViewModel {
    
    var page = 0
    
    override init() {
        super.init()
        self.modelCellType = (Address.self,AddressCell.self)
    }
    
    override func loadData() {
        page = 0
        loadingStatus = .loading
        API.loadJSON(Router.Address.list(page: page)) { (response) in
            if case .success(let json) = response {
                if let arr = json["list"].array {
                    self.sections = arr.map{ [Address(json:$0)] }
                }
                self.loadingStatus = .success
            } else {
                self.sections = []
                self.loadingStatus = .error
            }
            self.listView?.reload()
        }
    }

}
