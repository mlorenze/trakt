//
//  ServerHelper.swift
//  trakt
//
//  Created by Manuel Lorenze Alagna on 2/9/19.
//  Copyright © 2019 Manuel Lorenze Alagna. All rights reserved.
//

import Foundation

enum Environment: Int {
    case Stage = 0
    case Production = 1
    
    var name: String {
        switch self {
        case .Stage:
            return "STAGE"
        case .Production:
            return "PRODUCTION"
        }
    }
}

class ServerHelper {
    
    static let shared = ServerHelper()
    
    private var environment: Environment
    
    private init() {
        self.environment = ServerConfig.environment
    }
    
    func changeEnvironmentAllowed() -> Bool {
        return ServerConfig.changeEnvironmentEnabled && (ServerConfig.environment != Environment.Production)
    }
    
    func getEnvironment() -> Environment {
        return environment
    }
    
    func changeEnvironment(env: Environment) {
        precondition(changeEnvironmentAllowed())
        self.environment = env
    }

    func getTraktURL() -> String {
        switch self.environment {
        case .Stage:
            return K.StageServer.traktURL
        case .Production:
            return K.ProductionServer.traktURL
        }
    }

}
