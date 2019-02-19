//
//  MovieResponse.swift
//  trakt
//
//  Created by Manuel Lorenze Alagna on 2/18/19.
//  Copyright © 2019 Manuel Lorenze Alagna. All rights reserved.
//

import Foundation

struct MovieResponse: Codable {
    let title: String?
    let year: Int?
    let ids: IdsResponse?
}

extension MovieResponse {
    enum CodingKeys: String, CodingKey {
        case title
        case year
        case ids
    }
}
