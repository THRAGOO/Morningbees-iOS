//
//  NetworkItem.swift
//  Morningbees-iOS
//
//  Created by Byeongjo Koo on 2020/04/13.
//  Copyright © 2020 JUN LEE. All rights reserved.
//

import Foundation

enum Path: String {
    case base = "https://api-morningbees.thragoo.com"
    
    case signIn = "/api/auth/sign_in"
    case signUp = "/api/auth/sign_up"
    case validNickname = "/api/auth/valid_nickname"
    
    case renewal = "/api/auth/renewal"
    case me = "/api/auth/me"
    
    case beeCreate = "/api/bees"
    case missionCreate = "/api/missions"
    
    case beeInfo = "/api/my_bee"
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
    
    case contentType = "Content-Type"
    case accept = "Accept"
}
