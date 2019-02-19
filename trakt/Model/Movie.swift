//
//  Movie.swift
//  trakt
//
//  Created by Manuel Lorenze Alagna on 2/9/19.
//  Copyright © 2019 Manuel Lorenze Alagna. All rights reserved.
//

import Foundation

class Movie: NSObject {
    let title: String
    let year: Int
    let ids: [String : AnyObject]
    
    init(title: String, year: Int, idsResponse: IdsResponse) {
        self.title = title
        self.year = year
        self.ids = [String:AnyObject]()
    }
}
