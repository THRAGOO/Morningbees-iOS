//
//  NetworkRequest.swift
//  Morningbees-iOS
//
//  Created by iiwii on 2019/12/18.
//  Copyright © 2019 JUN LEE. All rights reserved.
//

import Foundation

final class Request<Model> where Model: Decodable {
    
    private let session = URLSession(configuration: .default)
}

extension Request {
    
    func request<T: Encodable>(req: RequestSet,
                               header: [String: String]? = nil,
                               param: T,
                               completion: @escaping (Model?, _ created: Bool, Error?) -> Void) {
        var urlComponents: URLComponents = {
            var components = URLComponents()
            components.scheme = Path.scheme.rawValue
            components.host = Path.host.rawValue
            components.path = req.path.rawValue
            return components
        }()
        guard let requestURL = urlComponents.url else {
            completion(nil, false, ResponseError.unknown)
            return
        }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = req.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        if let headerParams = header {
            for header in headerParams {
                request.setValue(header.value, forHTTPHeaderField: header.key)
            }
        }
        
        switch req.method {
        case .get, .delete:
            if let queryParams = param as? [String: Any] {
                urlComponents.queryItems = queryParams.map({ (key, value) -> URLQueryItem in
                    URLQueryItem(name: key, value: "\(value)")
                })
            }
            guard let requestURL = urlComponents.url else {
                completion(nil, false, ResponseError.unknown)
                return
            }
            request.url = requestURL
            
        case .post:
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            guard let httpBody = try? encoder.encode(param) else {
                completion(nil, false, ResponseError.unknown)
                return
            }
            request.httpBody = httpBody
        }
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(nil, false, error)
            }
            
            guard let data = data,
                  let response = response as? HTTPURLResponse else {
                completion(nil, false, ResponseError.unknown)
                return
            }
            
            switch response.statusCode {
            case ResponseCode.success.rawValue:
                guard let result = try? JSONDecoder().decode(Model.self, from: data) else {
                    completion(nil, false, ResponseError.unknown)
                    return
                }
                completion(result, false, nil)
                
            case ResponseCode.created.rawValue:
                completion(nil, true, nil)
                
            default:
                guard let failResult = try? JSONDecoder().decode(ServerError.self, from: data) else {
                    completion(nil, false, ResponseError.unknown)
                    return
                }
                
                if failResult.code == ErrorCode.expiredToken.rawValue {
                    RenewalToken().request { (result, error) in
                        if let error = error {
                            completion(nil, false, error)
                            return
                        }
                        if let success = result {
                            if success {
                                KeychainService.extractKeyChainToken { (accessToken, _, error) in
                                    if let error = error {
                                        completion(nil, false, error)
                                    }
                                    guard let accessToken = accessToken,
                                          var renewalHeader = header else {
                                        return
                                    }
                                    renewalHeader.updateValue(accessToken, forKey: RequestHeader.accessToken.rawValue)
                                    
                                    Request<Model>().request(req: req,
                                                             header: renewalHeader,
                                                             param: param) { (result, created, error)  in
                                        if let error = error {
                                            completion(nil, false, error)
                                        }
                                        guard let result = result else {
                                            return
                                        }
                                        completion(result, created, nil)
                                    }
                                }
                            } else {
                                NavigationControl().popToRootViewController()
                                completion(nil, false, nil)
                                return
                            }
                        }
                    }
                }
            }
        }
        dataTask.resume()
    }
}
