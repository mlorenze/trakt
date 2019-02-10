//
//  Person.swift
//  trakt
//
//  Created by Manuel Lorenze Alagna on 2/9/19.
//  Copyright © 2019 Manuel Lorenze Alagna. All rights reserved.
//

import Foundation

class Person: NSObject {
    let name: String
    let ids: [String : AnyObject]
    
    init(name: String, ids: [String : AnyObject]) {
        self.name = name
        self.ids = ids
    }
}
