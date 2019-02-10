//
//  Season.swift
//  trakt
//
//  Created by Manuel Lorenze Alagna on 2/9/19.
//  Copyright © 2019 Manuel Lorenze Alagna. All rights reserved.
//

import Foundation

class Season: NSObject {
    let number: Int
    let ids: [String : AnyObject]
    
    init(number: Int, ids: [String : AnyObject]) {
        self.number = number
        self.ids = ids
    }
}
