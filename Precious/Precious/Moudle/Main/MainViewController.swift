//
//  MainViewController.swift
//  Precious
//
//  Created by zhubch on 2017/12/13.
//  Copyright © 2017年 zhubch. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let imageNames = ["home","ssp","xsp","me"]
        self.tabBar.items?.forEachEnumerated({ (i, item) in
            item.image = UIImage(named: "icon_tabbar_\(imageNames[i])")?.origin
            item.selectedImage = UIImage(named: "icon_tabbar_\(imageNames[i])_s")?.origin
        })
        
        self.tabBar.tintColor = C.Color.gold
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if User.current?.token == nil {
            login()
        } else if User.current?.isTemp ?? true {
            bind()
        }
    }
    
    func login() {
        guard let vc = C.Storyboard.Login.entry else { return }
        present(vc, animated: false, completion: nil)
    }
    
    func bind() {
        guard let vc = C.Storyboard.Login.instantiateVC(RegisterViewController.self) else { return }
        vc.page = .bindPhone
        present(vc, animated: false, completion: nil)
    }
}
