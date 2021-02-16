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
    
    func request<T: Encodable>(request: RequestSet,
                               header: [String: String]? = nil,
                               parameter: T,
                               completion: @escaping (Model?, _ created: Bool, Error?) -> Void) {
        var urlComponents: URLComponents = {
            var components = URLComponents()
            components.scheme = Path.scheme.rawValue
            components.host = Path.host.rawValue
            let beeId = UserDefaults.standard.integer(forKey: UserDefaultsKey.beeId.rawValue)
            let path = request.path.rawValue.replacingOccurrences(of: "{beeid}",
                                                                  with: "\(beeId)")
            components.path = path
            return components
        }()
        guard let requestURL = urlComponents.url else {
            completion(nil, false, ResponseError.unknown)
            return
        }
        
        var urlRequest = URLRequest(url: requestURL)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        if let headerParams = header {
            for header in headerParams {
                urlRequest.setValue(header.value, forHTTPHeaderField: header.key)
            }
        }
        
        switch request.method {
        case .get, .delete:
            if let queryParams = parameter as? [String: Any] {
                urlComponents.queryItems = queryParams.map({ (key, value) -> URLQueryItem in
                    URLQueryItem(name: key, value: "\(value)")
                })
            }
            guard let requestUrl = urlComponents.url else {
                completion(nil, false, ResponseError.unknown)
                return
            }
            urlRequest.url = requestUrl
            
        case .post:
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            guard let httpBody = try? encoder.encode(parameter) else {
                completion(nil, false, ResponseError.unknown)
                return
            }
            urlRequest.httpBody = httpBody
        }
        
        let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
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
                    completion(nil, true, ResponseError.unknown)
                    return
                }
                completion(result, true, nil)
                
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
                                    
                                    Request<Model>().request(request: request,
                                                             header: renewalHeader,
                                                             parameter: parameter) { (result, created, error)  in
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
                                NavigationControl.popToRootViewController()
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
