//
//  GoodsViewController.swift
//  Precious
//
//  Created by zhubch on 2017/12/23.
//  Copyright © 2017年 zhubch. All rights reserved.
//

import UIKit

class GoodsViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topSpace: NSLayoutConstraint!

    var selectMode = false
    var completionHandler: (([Goods])->Void)?
    var viewModel: GoodsViewModel!
    
    override var shouldBack: Bool {
        if selectMode {
            let goods = viewModel.sections.first as! [Goods]
            completionHandler?(goods.filter{ $0.selected })
        }
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if selectMode {
            title = "选择拍品"
            topSpace.constant = 44
        }
        setupViewModel()
        tableView.viewModel = viewModel
    }
    
    func setupViewModel() {
        viewModel.loadData()
        viewModel.configureCellHandler = { (cell,_) in
            let goodsCell = cell as! SimpleGoodsCell
            goodsCell.selectedButton.isHidden = self.selectMode.toggled
        }
        viewModel.didSelectModelHandler = { model in
            let goods = model as! Goods
            self.performSegue(withIdentifier: "detail", sender: goods)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? GoodsDetailViewController {
            vc.goods = sender as! Goods
        }
    }
}
