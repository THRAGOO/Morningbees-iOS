//
//  RenewalRequest.swift
//  Morningbees-iOS
//
//  Created by Byeongjo Koo on 2020/03/22.
//  Copyright © 2020 JUN LEE. All rights reserved.
//

import UIKit

final class RenewalToken {
}

extension RenewalToken {
    
    func request(completion: @escaping (Bool?, Error?) -> Void) {
        
        //MARK: Request Set Up
        
        let session: URLSession = {
            let config = URLSessionConfiguration.default
            return URLSession(configuration: config)
        }()
        var urlComponents = URLComponents(string: Path.base.rawValue)
        let req = RequestSet(method: .post, path: .renewal)
        urlComponents?.path = req.path.rawValue
        
        KeychainService.extractKeyChainToken { (accessToken, refreshToken, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            guard let accessToken = accessToken,
                let refreshToken = refreshToken else {
                    print(KeychainError.noToken)
                    return
            }
            let headers: [String: String] = [RequestHeader.accessToken.rawValue: accessToken,
                                             RequestHeader.refreshToken.rawValue: refreshToken]
            guard let componentsURL = urlComponents?.url else {
                completion(nil, ResponseError.unknown)
                return
            }
            var request = URLRequest(url: componentsURL)
            request.httpMethod = req.method.rawValue
            for header in headers {
                request.setValue(header.value, forHTTPHeaderField: header.key)
            }
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
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
                        completion(nil, ResponseError.badRequest)
                        return
                    }
                    if failResult.code == ErrorCode.expiredToken.rawValue {
                        completion(false, nil)
                    }
                } else {
                    guard let result = try? JSONDecoder().decode(Renewal.self, from: data) else {
                        completion(nil, ResponseError.unknown)
                        return
                    }
                    KeychainService.updateKeychainToken(result.accessToken, refreshToken) { (error) in
                        completion(nil, error)
                    }
                    completion(true, nil)
                }
            }
            dataTask.resume()
        }
    }
}