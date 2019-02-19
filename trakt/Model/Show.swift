//
//  Show.swift
//  trakt
//
//  Created by Manuel Lorenze Alagna on 2/9/19.
//  Copyright © 2019 Manuel Lorenze Alagna. All rights reserved.
//

import Foundation

class Show: NSObject {
    let title: String
    let year: Int
    let ids: [String : AnyObject]
    
    init(title: String, year: Int, ids: [String : AnyObject]) {
        self.title = title
        self.year = year
        self.ids = ids
    }
}