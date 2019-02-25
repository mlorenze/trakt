//
//  Interactor.swift
//  trakt
//
//  Created by Manuel Lorenze Alagna on 2/9/19.
//  Copyright © 2019 Manuel Lorenze Alagna. All rights reserved.
//

import Foundation
import Alamofire
import BoltsSwift

protocol TraktInteractor {
    func getToken(code: String, completion:  @escaping (Token?, Error?) -> Void)
    func getToken(refreshToken: String, completion:  @escaping (Token?, Error?) -> Void)
    func revokeToken(token: String, completion:  @escaping (Bool) -> Void) 
    func getPopularMovies(page: Int, completion:  @escaping ([Movie]?, Error?) -> Void)
    func searchMovies(query: String, page: Int, completion:  @escaping ([Movie]?, Error?) -> Void)
    func getMovieImages(movieId: String, completion:  @escaping ([Poster]?, Error?) -> Void) -> Task<TaskResult>
}

class TraktInteractorImpl: TraktInteractor {
    
    let client: TraktClient
    let dispatchQueue = DispatchQueue(label: "interactorBackground")
    
    init() {
        self.client = TraktClient()
    }
    
    func getToken(code: String, completion:  @escaping (Token?, Error?) -> Void) {
        
        let tokenBody = TokenBody(code: code,
                                  clientId: TrankApi.id.rawValue,
                                  clientSecret: TrankApi.secret.rawValue,
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
                                  clientId: TrankApi.id.rawValue,
                                  clientSecret: TrankApi.secret.rawValue,
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
    
    func revokeToken(token: String, completion:  @escaping (Bool) -> Void) {
        
        let revokeToken = RevokeTokenBody(token: token,
                                          clientId: TrankApi.id.rawValue,
                                          clientSecret: TrankApi.secret.rawValue)
        
        client.revokeToken(revokeTokenBody: revokeToken) { (response) in
            switch response.result {
            case .success( _):
               completion(true)
            case .failure(let error):
                print(error)
                completion(false)
            }
        }
    }
    
    func getPopularMovies(page: Int, completion:  @escaping ([Movie]?, Error?) -> Void) {
        self.dispatchQueue.async {
            self.client.getPopularMovies(page: page) { (response) in
                switch response.result {
                case .success(let moviesResponse):
                    var movies: [Movie] = []
                    var index: Int = 1
                    for movieResponse in moviesResponse {
                        var rank: Int = 0
                        
                        if let pageNumberStr = response.response?.allHeaderFields["x-pagination-page"] as? String, let pageNumber = Int(pageNumberStr) {
                            rank = ((pageNumber - 1) * UISettings.maxCells) + index
                        }
                        index += 1
                        
                        movies.append(Movie(rank: rank, movieResponse: movieResponse))
                        
                    }
                    DispatchQueue.main.async {
                        completion(movies, nil)
                    }
                    
                case .failure(let error):
                    print(error)
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
    }
    
    func searchMovies(query: String, page: Int, completion:  @escaping ([Movie]?, Error?) -> Void) {
        self.dispatchQueue.async {
            self.client.getSearch(type: Search.movie, query: query, page: page) { (response) in
                switch response.result {
                case .success(let itemsResponse):
                    var movies: [Movie] = []
                    for itemResponse in itemsResponse {
                        movies.append(Movie(movieResponse: itemResponse.movie!))
                    }
                    DispatchQueue.main.async {
                        completion(movies, nil)
                    }
                    
                case .failure(let error):
                   // print(error)
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
    }
    
    func getMovieImages(movieId: String, completion:  @escaping ([Poster]?, Error?) -> Void) -> Task<TaskResult>  {
        let taskCompletionSource = TaskCompletionSource<TaskResult>()
        self.dispatchQueue.async {
            self.client.getMovieImages(movieId: movieId) { (response) in
                switch response.result {
                case .success(let movieImagesResponse):
                    
                    let posters = movieImagesResponse.posters?.map({ (posterResponse) -> Poster in
                        return Poster(posterResponse: posterResponse)
                    })
                    DispatchQueue.main.async {
                        completion(posters != nil ? posters : [Poster](), nil)
                    }
                    taskCompletionSource.set(result: TaskResult(result: MoviesDataStateResult.Success))
                case .failure(let error):
                    print(error)
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                    taskCompletionSource.set(error: error)
                }
            }
        }
        return taskCompletionSource.task
    }
}
