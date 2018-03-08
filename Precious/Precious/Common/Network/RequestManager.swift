//
//  RequestManager.swift
//  Precious
//
//  Created by zhubch on 2017/12/10.
//  Copyright © 2017年 zhubch. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

typealias JSONType = SwiftyJSON.JSON

typealias ValueResponse<T> = (Response<T>) -> Void
typealias JSONResponse = ValueResponse<JSONType>
typealias URLResponse = ValueResponse<[String]>

typealias API = RequestManager

enum Response<T> {
    case success(value: T)
    case failure(errMsg: String)
}

class RequestManager: NSObject {
    
    static let manager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForResource = 10
        return SessionManager(configuration: configuration)
    }()
    
    static func loadJSON(_ router: Routable, completionHandler: @escaping JSONResponse) {
        manager
            .request(router)
            .responseData(completionHandler: { (response) in
                if let data = response.data {
                    if let json = try? JSONType(data: data) {
                        if (json["code"].int ?? -1) == 200 {
                            completionHandler(.success(value: json["data"]))
                        } else {
                            completionHandler(.failure(errMsg: json["msg"].string ?? ""))
                        }
                    } else {
                        print(data.toString!)
                        completionHandler(.failure(errMsg:"无法解析json"))
                    }
                } else if let error = response.error {
                    completionHandler(.failure(errMsg:error.localizedDescription))
                }
            })
    }
    
    static func loadValue<T>(_ router: Routable,valueType: T.Type , completionHandler: @escaping ValueResponse<T>) {
        manager
            .request(router)
            .responseData(completionHandler: { (response) in
                if let data = response.data {
                    if let json = try? JSONType(data: data) {
                        if (json["code"].int ?? -1) == 200 {
                            if let value = json["data"] as? T {
                                completionHandler(.success(value: value))
                            } else {
                                completionHandler(.failure(errMsg: "未能解析为对应类型的Value"))
                            }
                        } else {
                            completionHandler(.failure(errMsg: json["msg"].string ?? ""))
                        }
                    } else {
                        print(data.toString!)
                        completionHandler(.failure(errMsg:"无法解析json"))
                    }
                } else if let error = response.error {
                    completionHandler(.failure(errMsg:error.localizedDescription))
                }
            })
    }
    
    static func uploadImage(_ image: UIImage, completionHandler:@escaping URLResponse) {
        guard let data = UIImageJPEGRepresentation(image, 0.8) else { return }
        let url = "http://39.106.143.142:8080/api/v2/upload/image"
        manager.upload(multipartFormData: { (formData) in
            formData.append(data, withName: "file", fileName: "zbc.jpeg", mimeType: "image/jpeg")
        }, to: url) { (result) in
            switch result {
            case .success(let upload, _, _ ):
                upload.responseJSON {
                    if let json = $0.result.value {
                        let info = JSON(json)
                        if let urls = info["data"].array {
                            completionHandler(.success(value:urls.map{$0["fileUri"].string ?? ""}))
                        } else {
                            completionHandler(.failure(errMsg:"上传失败"))
                        }
                    } else {
                        completionHandler(.failure(errMsg:"无法解析图片"))
                    }
                }
            case .failure(let error):
                completionHandler(.failure(errMsg:error.localizedDescription))
            }
        }
    }
}
