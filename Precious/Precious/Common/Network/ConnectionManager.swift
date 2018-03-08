//
//  ConnectionManager.swift
//  Precious
//
//  Created by zhubch on 2018/1/12.
//  Copyright © 2018年 zhubch. All rights reserved.
//

import UIKit
import Starscream
import SwiftyJSON

protocol MessageHandler: NSObjectProtocol {
    func handMessage(_ message: Message)
}

class Connection {
    fileprivate var webSocket: WebSocket?
    fileprivate var stoped = false

    weak var handler: MessageHandler?

    init(url: String) {
        guard let url = URL(string: url) else { return }
        webSocket = WebSocket(url: url)
        webSocket?.delegate = self
        connect()
    }
    
    func sendMessage(_ message: Message) {
        print("send:\n\(message.jsonString)")
        webSocket?.write(string: message.jsonString)
    }
    
    func connect() {
        stoped = false
        webSocket?.connect()
    }
    
    func disconnect() {
        stoped = true
        webSocket?.disconnect()
    }
    
    deinit {
        webSocket?.disconnect()
    }
}

extension Connection: WebSocketDelegate {
    func websocketDidConnect(socket: WebSocketClient) {
        print("websocket connected")
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("websocket closed \(error?.localizedDescription ?? "")")
        if stoped {
            return
        }
        Timer.runThisAfterDelay(seconds: 5) {
            print("retry connect")
            socket.connect()
        }
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        
        let json = JSON(parseJSON: text)
        let msg = Message(json: json)
        handler?.handMessage(msg)
        print(text)
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print(data.toString ?? "")
    }
}


