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

    
}
