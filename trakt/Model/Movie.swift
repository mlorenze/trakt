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
    let tagline: String
    let overview: String
    let released: String
    let runtime: Int
    let country: String
    let trailer: String
    let homepage: String
    let rating: Float
    let votes: Int
    let commentCount: Int
    let updatedAt: Date?
    let language: String
    let availableTranslations: [String]
    let genres: [String]
    let certification: String
    
    init(movieResponse: MovieResponse) {
        self.title = movieResponse.title ?? ""
        self.year = movieResponse.year ?? 0
        self.ids = [String:AnyObject]()
        
        self.tagline = movieResponse.tagline ?? ""
        self.overview = movieResponse.overview ?? ""
        self.released = movieResponse.released ?? ""
        self.runtime = movieResponse.runtime ?? 0
        self.country = movieResponse.country ?? ""
        self.trailer = movieResponse.trailer ?? ""
        self.homepage = movieResponse.homepage ?? ""
        self.rating = movieResponse.rating ?? 0
        self.votes = movieResponse.votes ?? 0
        self.commentCount = movieResponse.commentCount ?? 0
        self.updatedAt = movieResponse.updatedAt ?? nil
        self.language = movieResponse.language ?? ""
        self.availableTranslations = movieResponse.availableTranslations ?? []
        self.genres = movieResponse.genres ?? []
        self.certification = movieResponse.certification ?? ""
    }
}
