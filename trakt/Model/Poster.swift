//
//  Poster.swift
//  trakt
//
//  Created by Manuel Lorenze Alagna on 2/22/19.
//  Copyright © 2019 Manuel Lorenze Alagna. All rights reserved.
//

import Foundation

class Poster: NSObject {
    
    let aspectRatio: Float
    let filePath: String
    let height: Int
    let width: Int
    
    init(posterResponse: PosterResponse) {
        self.aspectRatio = posterResponse.aspectRatio ?? 0
        self.filePath = posterResponse.filePath ?? ""
        self.height = posterResponse.height ?? 0
        self.width = posterResponse.width ?? 0
    }

}
