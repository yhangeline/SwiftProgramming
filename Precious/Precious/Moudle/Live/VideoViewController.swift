//
//  VideoViewController.swift
//  Precious
//
//  Created by zhubch on 2018/1/8.
//  Copyright © 2018年 zhubch. All rights reserved.
//

import UIKit
import RxSwift
import AliyunPlayerSDK
import AlivcLivePusher

class VideoViewController: BaseViewController, LiveContent {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var looksLabel: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    
    @IBOutlet weak var goodsView: UIView!
    @IBOutlet weak var goodsAvatar: UIImageView!
    @IBOutlet weak var goodsNameLabel: UILabel!
    @IBOutlet weak var countDownLabel: UILabel!

    private var player: AliVcMediaPlayer?
    
    private var pusher: AlivcLivePusher?

    private let videoView = UIView(x: 0, y: 0, w: C.windowWidth, h: C.windowHeight)

    private let viewModel = VideoViewModel()

    private var bag = DisposeBag()
    
    var auction: Auction!
    
    var goods: Goods?
    
    var liveInfo: LiveInfo!

    override var showNavigationBar: Bool {
        return false
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        if auction.isOwn {
            setupPusher()
        } else {
            setupPlayer()
        }
    }
    
    
    func setupUI() {
        looksLabel.text = auction.looksCount.toString + " 人围观"
        nameLabel.text = auction.userName
        avatar.setImageWith(url: auction.userImage, placeholder: #imageLiteral(resourceName: "img_default_head"))
        
        tableView.viewModel = viewModel
        view.insertSubview(videoView, at: 0)
    }
    
    func setupPlayer() {
        let url = URL(string: "rtmp://live.hkstv.hk.lxdns.com/live/hks")
        
        let player = AliVcMediaPlayer()
        player.create(videoView)
        player.prepare(toPlay: url)
        player.play()
        
        self.player = player
    }
    
    func setupPusher() {
        let conf = AlivcLivePushConfig(resolution: .resolution720P)
        
        let pusher = AlivcLivePusher(config: conf)!
        pusher.startPreview(videoView)
        pusher.startPush(withURL: liveInfo.pushStreamUrl)
        self.pusher = pusher
    }
    
    func cleanUp() {
        player?.stop()
        player?.destroy()
        
        pusher?.stopPreview()
        pusher?.stopPush()
        pusher?.destory()
    }

    @IBAction func close(_ sender: UIButton) {
        dismissVC(completion: nil)
        cleanUp()
    }
    
    @IBAction func showGoods(_ sender: UIButton) {
        let v = GoodsInfoView.instance()
        v.goods = self.goods
        popUp(view: v)
    }
    
    func appendMessage(_ msg: Message) {
        self.viewModel.append(msg)
        self.tableView.scrollToBottom()
    }
    
    func updateGoods(_ goods: Goods?) {
        self.goods = goods
        if let goods = goods {
            goodsView.isHidden = false
            goodsNameLabel.text = goods.name
            goodsAvatar.setImageWith(url: goods.image)
            updateCountDown(goods.sellTime ?? 0)
        } else {
            goodsView.isHidden = true
        }
    }
    
    func updateLookers(_ count: Int) {
        looksLabel.text = "\(count) 人围观"
    }
    
    func updateCountDown(_ sec: Int) {
        bag = DisposeBag()
        
        time(from:100).asObservable().map{$0.time}.map{"\($1):\($2)"}.bind(to: countDownLabel.rx.text).disposed(by: bag)
    }
}

