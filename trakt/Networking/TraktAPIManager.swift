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
    
    var token: Token?

    var OAuthTokenCompletionHandler:((Error?) -> Void)?
    
    func hasOAuthToken() -> Bool {
        if let accessToken = self.getOAuthToken()
        {
            return !accessToken.isEmpty
        }
        return false
    }
    
    func startOAuth2Login() {
        if let authURL = TraktEndPoint.authorize().asURL() {
            UIApplication.shared.open(authURL, options: [:]) { (result) in
                print(result)
            }
        }
    }
    
    func processOAuthStep1Response(url: URL) {
       
        let components = NSURLComponents(url: url, resolvingAgainstBaseURL: false)
        var code:String?
        if let queryItems = components?.queryItems {
            for queryItem in queryItems {
                if (queryItem.name.lowercased() == "code") {
                    code = queryItem.value
                    break
                }
            }
        }
        
        if let receivedCode = code {
            traktInteractor.getToken(code: receivedCode) { (token, error) in
                if let anError = error {
                    print(anError)
                    if let completionHandler = self.OAuthTokenCompletionHandler {
                        let noOAuthError = NSError(domain: "AlamofireErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Could not obtain an OAuth token", NSLocalizedRecoverySuggestionErrorKey: "Please retry your request"])
                        completionHandler(noOAuthError as Error)
                    }
                    return
                }
                
                self.token = token
            }
        }
    }
    
    func getOAuthToken() -> String? {
        return token?.accessToken
    }
}
