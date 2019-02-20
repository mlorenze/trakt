//
//  ImageResponse.swift
//  trakt
//
//  Created by Manuel Lorenze Alagna on 2/19/19.
//  Copyright © 2019 Manuel Lorenze Alagna. All rights reserved.
//

import Foundation

struct ImagesResponse: Codable {
    let id: Int?
    //let backdrops: String?
    let posters: [PosterResponse]?
}

extension ImagesResponse {
    enum CodingKeys: String, CodingKey {
        case id
        //case backdrops
        case posters
    }
}
