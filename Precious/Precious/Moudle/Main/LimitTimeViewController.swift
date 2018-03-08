//
//  LimitTimeViewController.swift
//  Precious
//
//  Created by zhubch on 2018/1/20.
//  Copyright © 2018年 zhubch. All rights reserved.
//

import UIKit

class LimitTimeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let gradient = [C.Color.white, C.Color.background].gradient { gradient in
            gradient.locations = [0, 1]
            return gradient
        }
        gradient.frame = view.layer.bounds
        view.layer.insertSublayer(gradient, at: 0)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! AuctionsViewController
        let status = [Auction.Status.selling,Auction.Status.toSell]
        vc.viewModel = AuctionsViewModel(status: status, realTime: false, all: true)
    }
}
