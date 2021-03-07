//
//  MultipartFormdataRequest.swift
//  Morningbees-iOS
//
//  Created by Byeongjo Koo on 2021/01/02.
//  Copyright © 2021 THRAGOO. All rights reserved.
//

import Foundation

final class MultipartFormdataRequest {
    
    private let session = URLSession(configuration: .default)
    private let dateFormatter: DateFormatter = {
        let date = DateFormatter()
        date.dateStyle = .short
        date.timeStyle = .medium
        date.locale = .autoupdatingCurrent
        return date
    }()
}

extension MultipartFormdataRequest {
    
    func request(parameters: [String: String],
                 imageData: Data,
                 requestSet: RequestSet,
                 header: [String: String]? = nil,
                 completion: @escaping(_ created: Bool, CustomError?) -> Void) {
        let boundaryConstant = UUID().uuidString
        let prefixBoundary = "--" + boundaryConstant + "\r\n"
        let suffixBoundary = "--" + boundaryConstant + "--"
        
        let fileName = dateFormatter.string(from: Date()) + ".jpg"
        
        let urlComponents: URLComponents = {
            var components = URLComponents()
            components.scheme = Path.scheme.rawValue
            components.host = Path.host.rawValue
            components.path = requestSet.path.rawValue
            return components
        }()
        guard let requestURL = urlComponents.url else {
            return
        }
        
        var bodyData = Data()
        bodyData.appendStringData(prefixBoundary)
        bodyData.appendStringData("Content-Disposition: form-data; name=\"image\"; filename=\"\(fileName)\"\r\n")
        bodyData.appendStringData("Content-Type: image/jpeg\r\n\r\n")
        bodyData.append(imageData)
        bodyData.appendStringData("\r\n")
        
        for (key, value) in parameters {
            bodyData.appendStringData(prefixBoundary)
            bodyData.appendStringData("Content-Disposition: form-data; name=\"\(key)\"\r\n")
            bodyData.appendStringData("Content-Type: text/plain\r\n\r\n")
            bodyData.appendStringData(value)
            bodyData.appendStringData("\r\n")
        }
        bodyData.appendStringData(suffixBoundary)
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = requestSet.method.rawValue
        request.setValue("multipart/form-data; boundary=\(boundaryConstant)", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        if let headerParams = header {
            for header in headerParams {
                request.setValue(header.value, forHTTPHeaderField: header.key)
            }
        }
        request.httpBody = bodyData
        
        let dataTask = session.dataTask(with: request) { (data, urlResponse, error) in
            if let error = error {
                let error = CustomError(errorType: .unknown, description: error.localizedDescription)
                completion(false, error)
                return
            }
            guard let urlResponse = urlResponse as? HTTPURLResponse,
                  let data = data else {
                completion(false, nil)
                return
            }
            
            if urlResponse.statusCode == ResponseCode.created.rawValue {
                completion(true, nil)
            } else {
                guard let failResult = try? JSONDecoder().decode(ServerError.self, from: data) else {
                    completion(false, nil)
                    return
                }
                let error = CustomError(errorType: .unknown, description: failResult.message)
                completion(false, error)
            }
        }
        dataTask.resume()
    }
}

extension Data {
    
    mutating func appendStringData(_ string: String) {
        guard let stringData = string.data(using: .utf8) else {
            return
        }
        self.append(stringData)
    }
}
