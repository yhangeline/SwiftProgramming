//
//  MenuViewController.swift
//  Precious
//
//  Created by zhubch on 2018/3/2.
//  Copyright © 2018年 zhubch. All rights reserved.
//

import UIKit
import Kingfisher

class MenuViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    let items = [
//                ("消息",#selector(message)),
                 ("清除缓存",#selector(clearCache)),
                 ("反馈",#selector(feedback)),
                 ("联系我们",#selector(about))]
    
    @objc func message() {
        performSegue(withIdentifier: "message", sender: nil)
    }
    
    @objc func clearCache() {
        startLoadingAnimation()
        let cache = KingfisherManager.shared.cache
        
        cache.calculateDiskCacheSize(completion: {
            let cacheSize = Int($0) / 1000
            if cacheSize == 0 {
                self.stopLoadingAnimation()
                showMessage("无需清理")
                return
            }
            let str = cacheSize > 1000 ? "已清理 \(cacheSize / 1000) MB" : "已清理 \(cacheSize) KB"
            
            cache.clearDiskCache {
                Timer.runThisAfterDelay(seconds: 1, after: {
                    self.stopLoadingAnimation()
                    showMessage(str)
                })
            }
        })
    }
    
    @objc func feedback() {
        performSegue(withIdentifier: "feedback", sender: nil)
    }
    
    @objc func about() {
        performSegue(withIdentifier: "about", sender: nil)
    }
    
    @IBAction func logout(_ sender: UIButton) {
        doAfterUserSure(title: "确定要退出登录吗？") {
            User.current?.clear()
            guard let vc = C.Storyboard.Login.entry else { return }
            self.present(vc, animated: false, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "更多"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menu", for: indexPath)
        let item = items[indexPath.row]
        cell.textLabel?.text = item.0
        let accessoryView = UIImageView(image: #imageLiteral(resourceName: "icon_home_more"))
        cell.accessoryView = accessoryView
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        perform(item.1)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
}
