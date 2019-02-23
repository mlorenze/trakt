//
//  ItemSearchedResponse.swift
//  trakt
//
//  Created by Manuel Lorenze Alagna on 2/22/19.
//  Copyright © 2019 Manuel Lorenze Alagna. All rights reserved.
//

import Foundation

struct ItemSearchedResponse: Codable {
    let type: String?
    let score: Float?
    let movie: MovieResponse?

}

extension ItemSearchedResponse {
    enum CodingKeys: String, CodingKey {
        case type
        case score
        case movie
    }
}
