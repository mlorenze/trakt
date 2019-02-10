//
//  TraktAPIManager.swift
//  trakt
//
//  Created by Manuel Lorenze Alagna on 2/9/19.
//  Copyright © 2019 Manuel Lorenze Alagna. All rights reserved.
//

import Foundation
import Alamofire

class TraktAPIManager {
    
    private let traktInteractor: TraktInteractor!
    
    private init() {
        self.traktInteractor = TraktInteractorImpl()
    }
    
    static let sharedInstance = TraktAPIManager()
    

    var OAuthTokenCompletionHandler:((NSError?) -> Void)?
    
    func hasOAuthToken() -> Bool {

        return false
    }
    
    func startOAuth2Login() {
        if let authURL = TraktEndPoint.authorize().asURL() {
            UIApplication.shared.open(authURL, options: [:]) { (result) in
                print(result)
            }
        }
    }
}
