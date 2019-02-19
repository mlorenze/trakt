//
//  IdsResponse.swift
//  trakt
//
//  Created by Manuel Lorenze Alagna on 2/18/19.
//  Copyright © 2019 Manuel Lorenze Alagna. All rights reserved.
//


import Foundation

struct IdsResponse: Codable {
    let trakt: Int?
    let slug: String?
    let imdb: String?
    let tmdb: Int?
}

extension IdsResponse {
    enum CodingKeys: String, CodingKey {
        case trakt
        case slug
        case imdb
        case tmdb
    }
}
