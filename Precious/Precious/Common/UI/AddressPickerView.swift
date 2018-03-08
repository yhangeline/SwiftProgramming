//
//  AddressPickerView.swift
//  AddressPickerViewForSwift
//
//  Created by Jonhory on 2017/3/21.
//  Copyright © 2017年 com.wujh. All rights reserved.
//

import UIKit

protocol AddressPickerViewDelegate: class {
    func addressSure(province: String?, city: String?, region: String?)
    
}

class AddressPickerView: UIPickerView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 239/255.0, green: 239/255.0, blue: 244/255.0, alpha: 1.0)
        self.delegate = self
        self.dataSource = self
        self.loadAddressData()
    }
    
    class Province {
        var name: String!
        var id: Int!
        var cityModelArr: [City] = []
    }
    
    class City {
        var name: String!
        var id: Int!
        var regionModelArr: [Region] = []
    }
    
    class Region {
        var name: String!
        var id: Int!
    }
    
    /// 数据源初始化
    var dataDict: [String: Any]?
    /// 省字典
    var provincesArr: [String]?
    /// 省ID字典
    var provinceIDDict: [String: Int]?
    /// 城市字典
    var citysDict: [String: Any]?
    /// 城市ID字典
    var cityIDDict: [String: Int]?
    /// 地区字典
    var regionsDict: [String: Any]?
    /// 地区ID字典
    var regionIDDict: [String: Int]?
    /// 整体数据源
    var provinceModelArr: [Province] = []
    
    //MARK: - 加载数据源
    private func loadAddressData() {
        let filePath = Bundle.main.path(forResource: "address", ofType: "json")
        if filePath == nil {
            print("加载数据源失败，请检查文件路径")
            return
        }
        var addressStr: String? = nil
        do {
            addressStr = try String.init(contentsOfFile: filePath!, encoding: .utf8)
        } catch {
            print("encoding error = ",error)
            return
        }
        dataDict = dictionaryWith(jsonString: addressStr)
        if dataDict == nil { return }
        
        provincesArr = dataDict!["province"] as! [String]?
        citysDict = dataDict!["city"] as! [String : Any]?
        regionsDict = dataDict!["region"] as! [String : Any]?
        
        if provincesArr == nil || citysDict == nil  || regionsDict == nil { return }
        
        provinceIDDict = dataDict!["provinceID"] as! [String: Int]?
        cityIDDict = dataDict!["cityID"] as! [String: Int]?
        regionIDDict = dataDict!["regionID"] as! [String: Int]?
        
        if provinceIDDict == nil || cityIDDict == nil || regionIDDict == nil { return }
        
        let provinceCount = provincesArr!.count
        for i in 0..<provinceCount {
            let pName = provincesArr![i]
            let citys = citysDict![pName] as! [String]
            let p = Province()
            p.name = pName
            p.id = provinceIDDict![pName]
            
            var cityModels: [City] = []
            for cityName in citys {
                let regionArr = regionsDict![cityName] as! [String]
                let cityModel = City()
                cityModel.id = cityIDDict![cityName]
                cityModel.name = cityName
                
                var regionModels: [Region] = []
                for regionName in regionArr {
                    let regionModel = Region()
                    regionModel.name = regionName
                    regionModel.id = regionIDDict![regionName]
                    regionModels.append(regionModel)
                }
                cityModel.regionModelArr = regionModels
                cityModels.append(cityModel)
            }
            p.cityModelArr = cityModels
            provinceModelArr.append(p)
        }
    }
    
    private func dictionaryWith(jsonString: String?) -> [String: Any]? {
        var dic: [String: Any]? = nil
        if jsonString != nil {
            let jsonData = jsonString!.data(using: .utf8)
            if jsonData != nil {
                do {
                    let dicc = try JSONSerialization.jsonObject(with: jsonData!, options: .mutableContainers)
                    dic = dicc as? [String: Any]
                } catch {
                    print("json error:",error)
                }
            }
        }
        return dic
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension AddressPickerView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return provinceModelArr[row].name
        case 1:
            let selectP = pickerView.selectedRow(inComponent: 0)
            let p = provinceModelArr[selectP]
            if row > p.cityModelArr.count - 1 {
                return nil
            }
            return p.cityModelArr[row].name
        case 2:
            let selectP = pickerView.selectedRow(inComponent: 0)
            let selectC = pickerView.selectedRow(inComponent: 1)
            let p = provinceModelArr[selectP]
            if selectC > p.cityModelArr.count - 1 {
                return nil
            }
            let c = p.cityModelArr[selectC]
            if row > c.regionModelArr.count - 1 {
                return nil
            }
            return c.regionModelArr[row].name
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            let selectC = pickerView.selectedRow(inComponent: 1)
            let selectR = pickerView.selectedRow(inComponent: 2)
            pickerView.reloadComponent(1)
            pickerView.selectRow(selectC, inComponent: 1, animated: true)
            pickerView.reloadComponent(2)
            pickerView.selectRow(selectR, inComponent: 2, animated: true)
            break
        case 1:
            let selectR = pickerView.selectedRow(inComponent: 2)
            pickerView.reloadComponent(2)
            pickerView.selectRow(selectR, inComponent: 2, animated: true)
            break
        default:
            break
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label = view as? UILabel
        if label == nil {
            label = UILabel()
            label?.textColor = C.Color.black
            label?.adjustsFontSizeToFitWidth = true
            label?.textAlignment = .center
            label?.font = C.Font.normal.L
        }
        label?.text = self.pickerView(pickerView, titleForRow: row, forComponent: component)
        return label!
    }
}

extension AddressPickerView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return provinceModelArr.count
        case 1:
            let selectP = pickerView.selectedRow(inComponent: 0)
            return provinceModelArr[selectP].cityModelArr.count
        case 2:
            let selectP = pickerView.selectedRow(inComponent: 0)
            let selectC = pickerView.selectedRow(inComponent: 1)
            let p = provinceModelArr[selectP]
            if selectC > p.cityModelArr.count - 1 {
                return 0
            }
            return p.cityModelArr[selectC].regionModelArr.count
        default:
            return 0
        }
    }
}

