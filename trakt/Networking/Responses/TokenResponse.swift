//
//  TokenResponse.swift
//  trakt
//
//  Created by Manuel Lorenze Alagna on 2/9/19.
//  Copyright © 2019 Manuel Lorenze Alagna. All rights reserved.
//

import Foundation

struct TokenResponse: Codable {
    let accessToken: String?
}

extension TokenResponse {
    enum CodingKeys: String, CodingKey {
        case accessToken
    }
}
