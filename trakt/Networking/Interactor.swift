//
//  Interactor.swift
//  trakt
//
//  Created by Manuel Lorenze Alagna on 2/9/19.
//  Copyright © 2019 Manuel Lorenze Alagna. All rights reserved.
//

import Foundation
import Alamofire

protocol TraktInteractor {
    func getToken(code: String, completion:  @escaping (Token?, Error?) -> Void)
    func getToken(refreshToken: String, completion:  @escaping (Token?, Error?) -> Void)
    func getPopularMovies(completion:  @escaping ([Movie]?, Error?) -> Void)
}

class TraktInteractorImpl: TraktInteractor {
    
    let client: TraktClient
    
    init() {
        self.client = TraktClient()
    }
    
    func getToken(code: String, completion:  @escaping (Token?, Error?) -> Void) {
        
        let tokenBody = TokenBody(code: code,
                                  clientId: TrankClient.id.rawValue,
                                  clientSecret: TrankClient.secret.rawValue,
                                  redirectUri: K.AuthorizeAppParameters.Value.redirectURI,
                                  grantType: K.AuthorizeAppParameters.Value.grantType)
        
        client.getToken(tokenBody: tokenBody) { (response) in
            switch response.result {
            case .success(let tokenResponse):
                let token = Token(accessToken: tokenResponse.accessToken, tokenType: tokenResponse.tokenType, expiresIn: tokenResponse.expiresIn, refreshToken: tokenResponse.refreshToken, scope: tokenResponse.scope, createdAt: tokenResponse.createdAt)
                completion(token, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    func getToken(refreshToken: String, completion:  @escaping (Token?, Error?) -> Void) {

        let tokenBody = TokenBody(refreshToken: refreshToken,
                                  clientId: TrankClient.id.rawValue,
                                  clientSecret: TrankClient.secret.rawValue,
                                  redirectUri: K.AuthorizeAppParameters.Value.redirectURI,
                                  grantType: K.AuthorizeAppParameters.Value.grantType)

        client.getToken(tokenBody: tokenBody) { (response) in
            switch response.result {
            case .success(let tokenResponse):
                let token = Token(accessToken: tokenResponse.accessToken, tokenType: tokenResponse.tokenType, expiresIn: tokenResponse.expiresIn, refreshToken: tokenResponse.refreshToken, scope: tokenResponse.scope, createdAt: tokenResponse.createdAt)
                completion(token, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    func getPopularMovies(completion:  @escaping ([Movie]?, Error?) -> Void) {
        client.getPopularMovies { (response) in
            switch response.result {
            case .success(let moviesResponse):
                var movies: [Movie] = []
                for movieResponse in moviesResponse {
                    
                    movies.append(Movie(title: movieResponse.title!,
                                        year: movieResponse.year!,
                                        idsResponse: movieResponse.ids!))
                
                }
                completion(movies, nil)
               
            case .failure(let error):
                print(error)
                completion(nil, error)
            }
        }
    }
}
