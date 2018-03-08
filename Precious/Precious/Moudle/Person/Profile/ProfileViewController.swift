//
//  ProfileViewController.swift
//  Precious
//
//  Created by zhubch on 2017/12/20.
//  Copyright © 2017年 zhubch. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController, ImagePicker {
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var items: [[(String,String?,Selector)]]  {
        
        return [
            [
                ("昵称",User.current?.userName,#selector(nickName)),
                ("性别",User.current?.genderString,#selector(gender)),
                ("个人签名",User.current?.signature,#selector(bio))
            ],
            [     ("地址管理","",#selector(address)),
                  ("密码管理","",#selector(password))
            ]
        ]
    }
    
    override var shouldBack: Bool {
        save()
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "个人信息"
        self.avatarView.setImageWith(url: User.current?.image)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !isMovingToParentViewController {
            tableView.reload()
        }
    }
    
    func didPickImage(_ image: UIImage) {
        avatarView.startAnimating()
        API.uploadImage(image) { (response) in
            self.avatarView.stopAnimating()
            if case .success(let urls) = response {
                self.avatarView.setImageWith(url: urls.first)
                User.current?.image = urls.first
            }
        }
    }
    
    func save() {
        let user = User.current!
        user.save()
        let router = Router.User.updateInfo(avatar: user.image ?? "", userName: user.userName, bio: user.signature, gender: user.gender ?? 0)
        API.loadJSON(router) { (response) in
            if case .success(let json) = response {
                print(json)
            }
        }
    }
    
    @IBAction func avatar(_ sender: Any) {
        pickImage()
    }
    
    @objc func nickName() {
        self.performSegue(withIdentifier: "modify_name", sender: nil)
    }
    
    @objc func gender() {
        showActionSheet(actionTitles: ["男","女"]) { (index) in
            User.current?.gender = index
            self.tableView.reload()
        }
    }
    
    @objc func bio() {
        self.performSegue(withIdentifier: "modify_bio", sender: nil)
    }
    
    @objc func address() {
        self.performSegue(withIdentifier: "address", sender: nil)
    }
    
    @objc func password() {
        self.performSegue(withIdentifier: "password", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        switch identifier {
        case "modify_bio":
            let vc = segue.destination as! ModifyViewController
            vc.page = .bio
        case "modify_name":
            let vc = segue.destination as! ModifyViewController
            vc.page = .name
        default:
            break
        }
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "person", for: indexPath)
        let item = items[indexPath.section][indexPath.row]
        cell.textLabel?.text = item.0
        cell.detailTextLabel?.text = item.1
        let accessoryView = UIImageView(image: #imageLiteral(resourceName: "icon_home_more"))
        cell.accessoryView = accessoryView
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.section][indexPath.row]
        perform(item.2)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 16
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}

