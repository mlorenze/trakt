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
        static let traktURL = "https://api.trakt.tv"
    }

    struct StageServer {
        static let traktURL = "https://api-staging.trakt.tv"
    }
    
}

struct ServerConfig {
    // Set environment (STAGE or PRODUCTION)
    static let environment: Environment = Environment.Stage
    // Turn on or off drop down view from login to allow change of environment (in DEV or STAGE only)
    static let changeEnvironmentEnabled: Bool = false
}

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
    case acceptToken = "Access-Token"
}

enum ContentType: String {
    case json = "application/json"
}
