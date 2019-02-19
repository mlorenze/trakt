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
    let tagline: String?
    let overview: String?
    let released: String?
    let runtime: Int?
    let country: String?
    let trailer: String?
    let homepage: String?
    let rating: Float?
    let votes: Int?
    let commentCount: Int?
    let updatedAt: Date?
    let language: String?
    let availableTranslations: [String]?
    let genres: [String]?
    let certification: String?
}

extension MovieResponse {
    enum CodingKeys: String, CodingKey {
        case title
        case year
        case ids
        case tagline
        case overview
        case released
        case runtime
        case country
        case trailer
        case homepage
        case rating
        case votes
        case commentCount = "comment_count"
        case updatedAt = "updated_at"
        case language
        case availableTranslations = "available_translations"
        case genres
        case certification
    }
}
