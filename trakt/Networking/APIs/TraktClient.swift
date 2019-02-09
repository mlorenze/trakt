//
//  TraktClient.swift
//  trakt
//
//  Created by Manuel Lorenze Alagna on 2/9/19.
//  Copyright © 2019 Manuel Lorenze Alagna. All rights reserved.
//

import CodableAlamofire
import Alamofire

class OneClient {
    
    @discardableResult
    private func performRequest<T:Decodable>(route: TraktEndPoint, decoder: JSONDecoder = JSONDecoder(), completion:@escaping (DataResponse<T>)->Void) -> DataRequest {

        return Alamofire.request(route)
            .responseDecodableObject (decoder: decoder){ (response: DataResponse<T>) in
                completion(response)
        }
    }

    func postLogin(email: String, password: String, completion: @escaping (DataResponse<LoginResponse>) -> Void) {
        performRequest(route: TraktEndPoint.postLogin(email: email, password: password), completion: completion)
    }
}
