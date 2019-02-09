//
//  LoginBody.swift
//  trakt
//
//  Created by Manuel Lorenze Alagna on 2/9/19.
//  Copyright © 2019 Manuel Lorenze Alagna. All rights reserved.
//

import Foundation

class LoginBody: Codable {
    
    let email: String
    let password: String
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}

extension LoginBody {
    enum CodingKeys: String, CodingKey {
        case email
        case password
    }
}
