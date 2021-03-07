//
//  NetworkItem.swift
//  Morningbees-iOS
//
//  Created by Byeongjo Koo on 2020/04/13.
//  Copyright © 2020 JUN LEE. All rights reserved.
//

import Foundation

enum Path: String {
    
    case scheme = "https"
    case host = "api-morningbees.thragoo.com"
    case linkHost = "thragoo.page.link"
    
    case signIn = "/api/auth/sign_in"
    case signUp = "/api/auth/sign_up"
    case validNickname = "/api/auth/valid_nickname"
    
    case renewal = "/api/auth/renewal"
    case me = "/api/auth/me"
    
    case beeCreate = "/api/bees"
    case joinBee = "/api/bees/join"
    case missionCreate = "/api/missions"
    
    case main = "/api/main"
    case beeInfo = "/api/bees/{beeid}"
    
    case members = "/api/bees/{beeid}/members"
    case beePenalty = "/api/bee_penalties/{beeid}"
    case updateJelly = "/api/bee_penalties/paid/{beeid}"
    
    case beeWithdrawal = "/api/bees/withdrawal"
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
}

enum RequestHeader: String {
    case accessToken = "X-BEES-ACCESS-TOKEN"
    case refreshToken = "X-BEES-REFRESH-TOKEN"
    
    case contentType = "Content-Type"
    case accept = "Accept"
}

protocol RequestModel {

    associatedtype ModelType: Decodable
    var method: HTTPMethod { get set }
    var path: Path { get set }
}

final class RequestSet {

    let method: HTTPMethod
    let path: Path
    let customPath: String = ""
    
    init(
        method: HTTPMethod,
        path: Path
    ) {
        self.method = method
        self.path = path
    }
}
