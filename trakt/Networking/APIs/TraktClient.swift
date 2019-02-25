//
//  TraktClient.swift
//  trakt
//
//  Created by Manuel Lorenze Alagna on 2/9/19.
//  Copyright © 2019 Manuel Lorenze Alagna. All rights reserved.
//

import CodableAlamofire
import Alamofire

class TraktClient {
    
    @discardableResult
    private func performRequest<T:Decodable>(route: TraktEndPoint, decoder: JSONDecoder = JSONDecoder(), completion:@escaping (DataResponse<T>)->Void) -> DataRequest {
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601)

        return Alamofire.request(route)
            .responseDecodableObject (decoder: decoder){ (response: DataResponse<T>) in
                completion(response)
        }
    }
    
    func getToken(tokenBody: TokenBody, completion: @escaping(DataResponse<TokenResponse>) -> Void) {
        performRequest(route: TraktEndPoint.getToken(tokenBody: tokenBody), completion: completion)
    }
    
    func revokeToken(revokeTokenBody: RevokeTokenBody, completion: @escaping(DataResponse<EmptyResponse>) -> Void) {
        performRequest(route: TraktEndPoint.revokeToken(revokeTokenBody: revokeTokenBody), completion: completion)
    }
    
    func getPopularMovies(page: Int, completion: @escaping(DataResponse<[MovieResponse]>) -> Void) {
        performRequest(route: TraktEndPoint.getPopularMovies(page: page), completion: completion)
    }
    
    func getSearch(type: String,  query: String, page: Int, completion: @escaping(DataResponse<[ItemSearchedResponse]>) -> Void) {
        let searchEndpoint = TraktEndPoint.search(type: type, query: query, page: page)
        self.cancelPreviousRequest(with: searchEndpoint.path)
        performRequest(route: searchEndpoint, completion: completion)
    }
    
    func getMovieImages(movieId: String, completion: @escaping(DataResponse<ImagesResponse>) -> Void) {
        performRequest(route: TraktEndPoint.getMovieImages(movieId: movieId), completion: completion)
    }
    
    private func cancelPreviousRequest(with path: String) {
        let sessionManager = Alamofire.SessionManager.default
        sessionManager.session.getTasksWithCompletionHandler { dataTasks, uploadTasks, downloadTasks in
            dataTasks.forEach {
                print()
                if ($0.originalRequest?.url?.path == path) {
                    $0.cancel()
                }
            }
        }
    }
}
