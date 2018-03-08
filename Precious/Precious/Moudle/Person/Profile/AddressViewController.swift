//
//  AddressViewController.swift
//  Precious
//
//  Created by zhubch on 2017/12/23.
//  Copyright © 2017年 zhubch. All rights reserved.
//

import UIKit

class AddressViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var addressList = [Address]()
    let viewModel = AddressViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "地址管理"

        tableView.sectionFooterHeight = 10
        tableView.sectionHeaderHeight = 0.01
        tableView.viewModel = viewModel
        viewModel.configureCellHandler = { (cell,_) in
            let cell = cell as! AddressCell
            cell.delegate = self
        }
        viewModel.loadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? AddressEditViewController, let address = sender as? Address {
            vc.address = address
        }
    }
}

extension AddressViewController: AddressOperator {
    func deleteAddress(_ model: Address) {
        startLoadingAnimation()
        API.loadJSON(Router.Address.delete(id: model.id), completionHandler: { response in
            if case .success(let json) = response {
                print(json)
                self.viewModel.loadData()
            } else if case .failure(let err) = response{
                showMessage(err)
            }
            self.stopLoadingAnimation()
        })
    }
    
    func editAddress(_ model: Address) {
        performSegue(withIdentifier: "editAddress", sender: model)
    }

    func checkAddress(_ model: Address) {
        startLoadingAnimation()
        API.loadJSON(Router.Address.setDefault(id: model.id), completionHandler: { response in
            if case .success(let json) = response {
                print(json)
                self.viewModel.loadData()
            } else if case .failure(let err) = response{
                showMessage(err)
            }
            self.stopLoadingAnimation()
        })
    }
    
}

