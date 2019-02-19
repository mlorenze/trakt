//
//  RevokeTokenBody.swift
//  trakt
//
//  Created by Manuel Lorenze Alagna on 2/18/19.
//  Copyright © 2019 Manuel Lorenze Alagna. All rights reserved.
//

import Foundation

class RevokeTokenBody: Codable {
    
    let token: String
    let clientId: String
    let clientSecret: String
    
    init(token: String, clientId: String, clientSecret: String) {
        self.token = token
        self.clientId = clientId
        self.clientSecret = clientSecret
    }
}

extension RevokeTokenBody {
    enum CodingKeys: String, CodingKey {
        case token
        case clientId = "client_id"
        case clientSecret = "client_secret"
    }
}
