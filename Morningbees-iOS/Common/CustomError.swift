//
//  CustomError.swift
//  Morningbees-iOS
//
//  Created by Byeongjo Koo on 2021/03/05.
//  Copyright © 2021 THRAGOO. All rights reserved.
//

import Foundation

enum ResponseCode: Int {
    case success = 200
    case created = 201
}

enum ErrorCode: Int {
    case expiredToken = 101
    case badAccess = 110
}

enum ErrorDescription: String {
    case unhandledError = "예상치 못한 에러가 발생했습니다."
    case badRequest = "서버에 대한 잘못된 요청입니다."
    case internalServerError = "예상치 못한 서버 내부 오류가 발생했습니다."
    case foundNil = "해당 값을 찾아오지 못했습니다."
    
    case noToken = "토큰이 존재하지 않습니다."
    case unexpectedTokenData = "예상치 못한 토큰 데이터입니다."
}

struct CustomError: Error {
    
    enum ErrorType: Error {
        case unknown
        case badRequest
        case foundNil
        
        case noToken
        case unexpectedTokenData
        case unhandledError(status: OSStatus)
    }
    
    let errorType: ErrorType
    let description: String
}
