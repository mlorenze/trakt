//
//  TokenBody.swift
//  trakt
//
//  Created by Manuel Lorenze Alagna on 2/9/19.
//  Copyright © 2019 Manuel Lorenze Alagna. All rights reserved.
//

import Foundation

class TokenBody: Codable {
    
    let code: String?
    let refreshToken: String?
    let clientId: String
    let clientSecret: String
    let redirectUri: String
    let grantType: String

    init(code: String, clientId: String, clientSecret: String, redirectUri: String, grantType: String) {
        self.code = code
        self.refreshToken = nil
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.redirectUri = redirectUri
        self.grantType = grantType
    }
    
    init(refreshToken: String, clientId: String, clientSecret: String, redirectUri: String, grantType: String) {
        self.code = nil
        self.refreshToken = refreshToken
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.redirectUri = redirectUri
        self.grantType = grantType
    }
}

extension TokenBody {
    enum CodingKeys: String, CodingKey {
        case code
        case refreshToken = "refresh_token"
        case clientId = "client_id"
        case clientSecret = "client_secret"
        case redirectUri = "redirect_uri"
        case grantType = "grant_type"
    }
}
