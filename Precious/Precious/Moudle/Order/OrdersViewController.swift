//
//  OrdersViewController.swift
//  Precious
//
//  Created by zhubch on 2018/1/21.
//  Copyright © 2018年 zhubch. All rights reserved.
//

import UIKit

class OrdersViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: OrdersViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewModel()
        tableView.viewModel = viewModel
        tableView.tableHeaderView = UIView(x: 0, y: 0, w: 0, h: 1)
    }
    
    func setupViewModel() {
        viewModel.loadData()
        viewModel.didSelectModelHandler = {
            self.performSegue(withIdentifier: "detail", sender: $0)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? OrderDetailViewController, let order = sender as? Order {
            vc.order = order
        }
    }
    
}
