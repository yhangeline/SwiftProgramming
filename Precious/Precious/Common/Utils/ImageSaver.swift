//
//  ImageSaver.swift
//  WePost
//
//  Created by zhubch on 2017/4/12.
//  Copyright © 2017年 Happy Iterating Inc. All rights reserved.
//

import UIKit
import Photos

protocol ImageSaver: NSObjectProtocol {
    func saveImage(_ image: UIImage)
    var currentVC: UIViewController { get }
}

extension ImageSaver where Self: UIViewController {
    var currentVC: UIViewController {
        return self
    }
}

extension ImageSaver {
    func saveImage(_ image: UIImage) {

        let saveImageClosure: (UIImage) -> Void = { image in
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            }, completionHandler: { isSuccess, error in
                DispatchQueue.main.async {
                    if isSuccess {
                        showMessage("已保存到系统相册")
                    } else {
                        showError(error?.localizedDescription ?? "保存失败")
                    }
                }
            })
        }

        let authStatus = PHPhotoLibrary.authorizationStatus()
        switch authStatus {
        case .denied:
            currentVC.showAlert(title: "无法保存到相册，因为你没有允许微篇访问照片", message: "打开 设置->微篇 开启权限", actionTitles: ["取消","去设置"]) { (index) in
                if index == 1 {
                    UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
                }
            }
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ (status) in
                if status == .authorized {
                    saveImageClosure(image)
                }
            })
        case .authorized:
            saveImageClosure(image)
        default:
            saveImageClosure(image)
        }
    }
}

