//
//  Token.swift
//  trakt
//
//  Created by Manuel Lorenze Alagna on 2/10/19.
//  Copyright © 2019 Manuel Lorenze Alagna. All rights reserved.
//

import Foundation

class Token {
    
    let accessToken: String?
    let tokenType: String?
    let expiresIn: Int?
    let refreshToken: String?
    let scope: String?
    let createdAt: Int?
    
    init(accessToken: String?, tokenType: String?, expiresIn: Int?, refreshToken: String?, scope: String?, createdAt: Int?) {
        self.accessToken = accessToken
        self.tokenType = tokenType
        self.expiresIn = expiresIn
        self.refreshToken = refreshToken
        self.scope = scope
        self.createdAt = createdAt
    }
}
