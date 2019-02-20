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
    var ids: [String : AnyObject]
    let overview: String
    
    var imagesPath: [String]
    
    init(movieResponse: MovieResponse) {
        self.title = movieResponse.title ?? ""
        self.year = movieResponse.year ?? 0
        self.ids = [String:AnyObject]()
        self.ids["tmdb"] = movieResponse.ids?.tmdb as AnyObject
        self.overview = movieResponse.overview ?? ""
        self.imagesPath = [String]()
    }
    
    func setImagesPath(pathArray: [String]) {
        self.imagesPath = pathArray
    }
}
