//
//  Router.swift
//  Precious
//
//  Created by zhubch on 2017/12/6.
//  Copyright © 2017年 zhubch. All rights reserved.
//
import Foundation
import Alamofire

enum RequestMethod: String {
    case get     = "GET"
    case post    = "POST"
}

enum Condition: String {
    case develop
    case product
}

protocol IntConvertible {
    var intValue: Int { get }
}

extension Int: IntConvertible {
    var intValue: Int {
        return self
    }
}

typealias IntArray = Array<IntConvertible>

extension Array where Element == IntConvertible {
    var toString: String {
        var str = ""
        forEachEnumerated { (i, s) in
            str += (i == 0 ? "\(s.intValue)" : ",\(s.intValue)")
        }
        return str
    }
}

struct Router {
    
    struct Constant {
        static let developApiBaseUrl = "http://39.106.143.142:8080/"
        static let productApiBaseUrl = "http://39.106.143.142:8080/"
    }
    
    static var condition: Condition {
        get {
            guard
                let value = UserDefaults.standard.string(forKey: conditionKey),
                let condition = Condition(rawValue: value) else {
                    // 如果用户没有手动切换过环境，默认使用编译环境
                    #if DEBUG
                        return .develop
                    #else
                        return .product
                    #endif
            }
            return condition
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: conditionKey)
            UserDefaults.standard.synchronize()
        }
    }
    
    fileprivate static var baseURL: URL {
        switch condition {
        case .develop: return URL(string: Constant.developApiBaseUrl)!
        case .product: return URL(string: Constant.productApiBaseUrl)!
        }
    }
    
    private static let conditionKey = "Condition"
}

protocol Routable: URLRequestConvertible {
    var method: RequestMethod { get }
    var path: String { get }
    var parameters: [String: Any]? { get }
}

extension Routable {
    
    var url: URL {
        if path.contains("http") {
            return URL(string: path)!
        }
        return Router.baseURL.appendingPathComponent(path)
    }
    
    func asURLRequest() throws -> URLRequest {
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if let token = User.current?.token {
            request.setValue(token, forHTTPHeaderField: "token")
        }
        switch method {
        case .get:
            print(try URLEncoding.default.encode(request, with: parameters))
            return try URLEncoding.default.encode(request, with: parameters)
        case .post:
            print("\(method): \(url) \(parameters ?? [:])")
            return try JSONEncoding.default.encode(request, with: parameters)
        }
    }
    
}
