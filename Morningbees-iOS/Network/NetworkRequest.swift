//
//  NetworkRequest.swift
//  Morningbees-iOS
//
//  Created by iiwii on 2019/12/18.
//  Copyright © 2019 JUN LEE. All rights reserved.
//

import Foundation

enum HTTPSMethod: String {
    case get = "GET"
    case post = "POST"
}

enum SubURL: String {
    case validNickname = "/api/auth/valid_nickname"
    case signUp = "/api/auth/sign_up"
    case signIn = "/api/auth/sign_in"
}

struct AssembleURL {
    static let baseURLString = "https://api-morningbees.thragoo.com"
    static func getURL<T>(subURL: SubURL, value: T) -> URL? {
        if subURL == SubURL.validNickname {
            var url: URL? {
                var components = URLComponents(string: baseURLString)
                components?.path = SubURL.validNickname.rawValue
                components?.queryItems = [
                    URLQueryItem(name: "nickname", value: "\(value)")
                ]
                return components?.url
            }
            return url
        } else {
            return URL(string: baseURLString)
        }
    }
}

final class NetworkRequest {
    
    //MARK: Fetch Request
    
    static func fetchData(url: URL?, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        guard let url = url else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = HTTPSMethod.get.rawValue
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("error: \(error)")
            } else {
                guard let data = data else {
                    return
                }
                completionHandler(data, response, error)
            }
        }
        dataTask.resume()
    }
    
    //MARK: Upload Request
    
    static func uploadData(url: URL?,
                           uploadData: Data,
                           completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        guard let url = url else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = HTTPSMethod.post.rawValue
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
        let dataTask = session.uploadTask(with: request, from: uploadData) { (data, response, error) in
            if let error = error {
                print("error: \(error)")
            } else {
                guard let data = data else {
                    return
                }
                completionHandler(data, response, error)
            }
        }
        dataTask.resume()
    }
}
