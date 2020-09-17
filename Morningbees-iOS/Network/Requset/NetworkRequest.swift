//
//  NetworkRequest.swift
//  Morningbees-iOS
//
//  Created by iiwii on 2019/12/18.
//  Copyright © 2019 JUN LEE. All rights reserved.
//

import Foundation

protocol RequestModel {

    associatedtype ModelType: Decodable
    var method: HTTPMethod { get set }
    var path: Path { get set }
}

final class RequestSet {

    let method: HTTPMethod
    let path: Path
    
    init(
        method: HTTPMethod,
        path: Path
    ) {
        self.method = method
        self.path = path
    }
}

final class Request<Model> where Model: Decodable {

    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
}

extension Request {
    
    func request<T: Encodable>(req: RequestSet,
                               header: [String: String]? = nil,
                               param: T,
                               completion: @escaping (Model?, Error?) -> Void) {
        
        //MARK: Request Set Up
        
        var urlComponents = URLComponents(string: Path.base.rawValue)
        urlComponents?.path = req.path.rawValue
        if req.method == HTTPMethod.get {
            if let queryParams = param as? [String: String] {
                urlComponents?.queryItems = queryParams.map({ (key, value) -> URLQueryItem in
                    URLQueryItem(name: key, value: value)
                })
            }
        }
        guard let componentsURL = urlComponents?.url else {
            completion(nil, ResponseError.unknown)
            return
        }
        var request = URLRequest(url: componentsURL)
        request.httpMethod = req.method.rawValue
        
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let headerParams = header {
            for header in headerParams {
                request.setValue(header.value, forHTTPHeaderField: header.key)
            }
        }
        
        if req.method == HTTPMethod.post {
            if request.value(forHTTPHeaderField: "Content-Type")?.contains("multipart/form-data") ?? false {
                request.httpBody = param as? Data
            } else {
                let encoder = JSONEncoder()
                encoder.dateEncodingStrategy = .iso8601
                guard let httpBody = try? encoder.encode(param) else {
                    completion(nil, ResponseError.unknown)
                    return
                }
                request.httpBody = httpBody
            }
        }
        
        //MARK: Data Task

        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(nil, error)
            }
            guard let data = data,
                let response = response as? HTTPURLResponse else {
                completion(nil, ResponseError.unknown)
                return
            }
            
            if response.statusCode < 200 || 299 < response.statusCode {
                guard let failResult = try? JSONDecoder().decode(ServerError.self, from: data) else {
                    completion(nil, ResponseError.unknown)
                    return
                }
                
                if failResult.code == ErrorCode.expiredToken.rawValue {
                    RenewalToken().request { (success, error) in
                        if let error = error {
                            completion(nil, error)
                            return
                        }
                        if let success = success {
                            if success {
                                KeychainService.extractKeyChainToken { (accessToken, _, error) in
                                    if let error = error {
                                        completion(nil, error)
                                    }
                                    guard let accessToken = accessToken,
                                        var renewalHeader = header else {
                                        return
                                    }
                                    renewalHeader.updateValue(accessToken, forKey: RequestHeader.accessToken.rawValue)
                                
                                    Request<Model>().request(req: req,
                                                             header: renewalHeader,
                                                             param: param) { (result, error) in
                                        if let error = error {
                                            completion(nil, error)
                                        }
                                        guard let result = result else {
                                            return
                                        }
                                        completion(result, nil)
                                    }
                                }
                            } else {
                                NavigationControl().popToRootViewController()
                                completion(nil, nil)
                                return
                            }
                        }
                    }
                }
            } else if response.statusCode == 201 {
                completion(nil, nil)
            } else {
                guard let result = try? JSONDecoder().decode(Model.self, from: data) else {
                    completion(nil, ResponseError.unknown)
                    return
                }
                completion(result, nil)
            }
        }
        dataTask.resume()
    }
}
