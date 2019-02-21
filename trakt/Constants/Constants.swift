//
//  Constants.swift
//  trakt
//
//  Created by Manuel Lorenze Alagna on 2/9/19.
//  Copyright © 2019 Manuel Lorenze Alagna. All rights reserved.
//

import Foundation

struct K {

    /*----------Networking----------*/
    struct ProductionServer {
        static let authURL = "https://trakt.tv"
        static let traktURL = "https://api.trakt.tv"
    }

    struct StageServer {
        static let authURL = "https://trakt.tv"
        static let traktURL = "https://api-staging.trakt.tv"
    }
    
    struct TmbdServer {
        static let tmbdURL = "https://api.themoviedb.org/3"
    }
    
    struct AuthorizeAppParameters {
        
        struct Key {
            static let responseType = "response_type"
            static let clientId = "client_id"
            static let redirectURI = "redirect_uri"
            static let state = "state"
            static let grantType = "grant_type"
        }

        struct Value {
            static let responseType = "code"
            static let redirectURI = "com.belatrix.trakt://authorization"
            static let grantType = "authorization_code"
        }
    }
    
    struct Token {
        static let loadingOAuthToken = "loadingOAuthToken"
    }

}

struct ServerConfig {
    // Set environment (STAGE or PRODUCTION)
    static let environment: Environment = Environment.Production
    // Turn on or off drop down view from login to allow change of environment (in DEV or STAGE only)
    static let changeEnvironmentEnabled: Bool = false
}

enum HTTPHeaderField: String {
    case contentType = "Content-type"
    case traktApiKey = "trakt-api-key"
    case traktApiVersion = "trakt-api-version"
    case authorization = "Authorization"
    case acceptType = "Accept"
}

enum ContentType: String {
    case json = "application/json"
}

enum TrankApi: String {
    case id = "40394f912bbbd855a9a89395d0262630ca352025740137556d4beb9cd1696983"
    case secret = "5a8e0d82e6b9cd9d1a8b76638ecb9c7e1a57a6f14ba9affbb58ecdf52ebe4010"
    case version = "2"
}

enum TmbdApi: String {
    case tmbdImagesUrl = "https://image.tmdb.org/t/p/w500"
    case key = "67fcecb41ff40624c89725f225640da7"
}

struct UISettings {
    static let cellHeight: Float = 300
}
