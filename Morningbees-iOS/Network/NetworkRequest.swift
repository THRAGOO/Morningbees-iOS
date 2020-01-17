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
    case validNickname = "/api/auth/valid_nickname"
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

enum ResponseResult<T: Decodable> {
    case success(T)
    case failure(Error)
}

enum ResponseError: Error {
    case unknown
    case badRequest
}

protocol RequestModel {
//
    associatedtype ModelType: Decodable
    var method: HTTPMethod { get set }
    var path: Path { get set }
}

final class RequestSet {
//
    let method: HTTPMethod
    let path: Path
//    
    init(
        method: HTTPMethod,
        path: Path
    ) {
        self.method = method
        self.path = path
    }
}

final class Request<Model> where Model: Decodable {
//
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
//
    func request<T: Encodable>(req: RequestSet,
                               param: T,
                               completion: @escaping (Model?, Error?) -> Void) {
        var urlComponents = URLComponents(string: Path.base.rawValue)
        urlComponents?.path = req.path.rawValue
//
        if req.method == .get {
            if let dicParam = param as? [String: String?] {
                let items = dicParam.map { URLQueryItem(name: $0, value: $1) }
                urlComponents?.queryItems = items
            }
        }
//
        guard let componentsURL = urlComponents?.url else {
            completion(nil, ResponseError.unknown)
            return
        }
        var request = URLRequest(url: componentsURL)
        request.httpMethod = req.method.rawValue
//
        if req.method == .post {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            guard let httpBody = try? encoder.encode(param) else {
                completion(nil, ResponseError.unknown)
                return
            }
            request.httpBody = httpBody
        }
//
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("error: \(error)")
            } else {
                guard let data = data else {
                    completion(nil, ResponseError.unknown)
                    return
                }
                guard let response = response as? HTTPURLResponse,
                    (200...299).contains(response.statusCode) else {
                        completion(nil, ResponseError.badRequest)
                        return
                }
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
