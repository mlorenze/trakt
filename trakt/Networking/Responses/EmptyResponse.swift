//
//  EmptyResponse.swift
//  trakt
//
//  Created by Manuel Lorenze Alagna on 2/9/19.
//  Copyright © 2019 Manuel Lorenze Alagna. All rights reserved.
//

import Foundation

struct EmptyResponse: Codable {
    let message: String?
}

extension EmptyResponse {
    enum CodingKeys: String, CodingKey {
        case message
    }
}
