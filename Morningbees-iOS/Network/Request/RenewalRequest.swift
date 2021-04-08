//
//  RenewalRequest.swift
//  Morningbees-iOS
//
//  Created by Byeongjo Koo on 2020/03/22.
//  Copyright © 2020 JUN LEE. All rights reserved.
//

import UIKit

final class RenewalToken {
    
    private let session = URLSession(configuration: .default)
}

extension RenewalToken {
    
    func request(completion: @escaping (Bool, CustomError?) -> Void) {
        KeychainService.extractKeyChainToken { (accessToken, refreshToken, error) in
            if let error = error {
                completion(false, error)
            }
            guard let accessToken = accessToken,
                  let refreshToken = refreshToken else {
                let error = CustomError(errorType: .foundNil, description: ErrorDescription.foundNil.rawValue)
                completion(false, error)
                return
            }
            
            let urlComponents: URLComponents = {
                var components = URLComponents()
                components.scheme = Path.scheme.rawValue
                components.host = Path.host.rawValue
                components.path = Path.renewal.rawValue
                return components
            }()
            guard let requestURL = urlComponents.url else {
                let error = CustomError(errorType: .foundNil, description: ErrorDescription.foundNil.rawValue)
                completion(false, error)
                return
            }
            
            var urlRequest = URLRequest(url: requestURL)
            urlRequest.httpMethod = HTTPMethod.post.rawValue
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
            let headers: [String: String] = [RequestHeader.accessToken.rawValue: accessToken,
                                             RequestHeader.refreshToken.rawValue: refreshToken]
            for header in headers {
                urlRequest.setValue(header.value, forHTTPHeaderField: header.key)
            }
            
            let dataTask = self.session.dataTask(with: urlRequest) { (data, response, error) in
                if let error = error {
                    let error = CustomError(errorType: .unknown, description: error.localizedDescription)
                    completion(false, error)
                }
                
                guard let data = data,
                      let response = response as? HTTPURLResponse else {
                    let error = CustomError(errorType: .foundNil, description: ErrorDescription.foundNil.rawValue)
                    completion(false, error)
                    return
                }
                
                switch response.statusCode {
                case ResponseCode.success.rawValue:
                    guard let result = try? JSONDecoder().decode(Renewal.self, from: data) else {
                        let error = CustomError(errorType: .foundNil, description: ErrorDescription.foundNil.rawValue)
                        completion(false, error)
                        return
                    }
                    KeychainService.updateKeychainToken(result.accessToken, refreshToken) { (error) in
                        completion(false, error)
                    }
                    completion(true, nil)
                    
                default:
                    completion(false, nil)
                }
            }
            dataTask.resume()
        }
    }
}
