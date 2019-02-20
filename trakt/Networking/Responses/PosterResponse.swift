//
//  PosterResponse.swift
//  trakt
//
//  Created by Manuel Lorenze Alagna on 2/19/19.
//  Copyright © 2019 Manuel Lorenze Alagna. All rights reserved.
//

import Foundation

struct PosterResponse: Codable {
    let aspectRatio: Float?
    let filePath: String?
    let height: Int?
    let width: Int?
}

extension PosterResponse {
    enum CodingKeys: String, CodingKey {
        case aspectRatio = "aspect_ratio"
        case filePath = "file_path"
        case height
        case width
    }
}
