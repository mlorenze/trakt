//
//  Episode.swift
//  trakt
//
//  Created by Manuel Lorenze Alagna on 2/9/19.
//  Copyright © 2019 Manuel Lorenze Alagna. All rights reserved.
//

import Foundation

class Episode: NSObject {
    let season: Season
    let number: Int
    let title: String
    let ids: [String : AnyObject]
    
    init(season: Season, number: Int, title: String, ids: [String : AnyObject]) {
        self.season = season
        self.number = number
        self.title = title
        self.ids = ids
    }
}
