//
//  NetworkRequest.swift
//  Morningbees-iOS
//
//  Created by iiwii on 2019/12/18.
//  Copyright © 2019 JUN LEE. All rights reserved.
//

import Foundation

enum Path: String {
    case base = "https://api-morningbees.thragoo.com"
    
    case signIn = "/api/auth/sign_in"
    case signUp = "/api/auth/sign_up"
    case validNickname = "/api/auth/valid_nickname"
    
    case renewal = "/api/auth/renewal"
    case me = "/api/auth/me"
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

enum ResponseError: Error {
    case unknown
    case badRequest
}

enum ErrorCode: Int {
    case expiredToken = 101
    case badAccess = 110
}

enum RequestHeader: String {
    case accessToken = "X-BEES-ACCESS-TOKEN"
    case refreshToken = "X-BEES-REFRESH-TOKEN"
}

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
        
        if let headerParams = header {
            for header in headerParams {
                request.setValue(header.value, forHTTPHeaderField: header.key)
            }
        }
        
        if req.method == HTTPMethod.post {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            guard let httpBody = try? encoder.encode(param) else {
                completion(nil, ResponseError.unknown)
                return
            }
            request.httpBody = httpBody
        }
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

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
                    RenewalToken().request { (error) in
                        completion(nil, error)
                    }
                }
                completion(nil, ResponseError.badRequest)
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
