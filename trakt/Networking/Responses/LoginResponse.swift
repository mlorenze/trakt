//
//  LoginResponse.swift
//  trakt
//
//  Created by Manuel Lorenze Alagna on 2/9/19.
//  Copyright © 2019 Manuel Lorenze Alagna. All rights reserved.
//

import Foundation

struct LoginResponse: Codable {
    let login: Bool?
    let userID: String?
    let accessToken: String?
    let refreshToken: String?
    let expirationDate: String?
}

extension LoginResponse {
    enum CodingKeys: String, CodingKey {
        case login
        case userID = "userId"
        case accessToken
        case refreshToken
        case expirationDate
    }
}
