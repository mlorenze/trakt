//
//  TraktEndPoint.swift
//  trakt
//
//  Created by Manuel Lorenze Alagna on 2/9/19.
//  Copyright © 2019 Manuel Lorenze Alagna. All rights reserved.
//

import Foundation
import CodableAlamofire
import Alamofire
import SwiftyUserDefaults
import SwifterSwift

enum TraktEndPoint: APIConfiguration {
    
    case authorize()
    case getToken(tokenBody: TokenBody)
    
    var method: HTTPMethod {
        switch self {
        case .authorize:
            return .get
        case .getToken:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .authorize():
            return "/oauth/authorize"
        case .getToken(_):
            return "/oauth/token"
        }
    }
    
    var parameters: Parameters? {
        switch self {
        
        default:
            return nil
        }
    }
    
    var query: Parameters? {
        switch self {
        case .authorize():
            return [K.AuthorizeAppParameters.Key.responseType: K.AuthorizeAppParameters.Value.responseType,
                    K.AuthorizeAppParameters.Key.clientId: TrankClient.id.rawValue,
                    K.AuthorizeAppParameters.Key.redirectURI: K.AuthorizeAppParameters.Value.redirectURI]
        default:
            return nil
        }
    }
    
    var body: Data? {
        let encoder = JSONEncoder()
        switch self {
        case .getToken(let tokenBody):
            return try! encoder.encode(tokenBody)
        default:
            return nil
        }
    }
    
    // we have to add this header to the asURL request method
    var headers: [String: String] {
        switch self {
            
        default:
            return [String: String]()
        }
    }
    
    var tokenRequired: Bool {
        switch self {
            
        default:
            return false
        }
    }
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        var url = try ServerHelper.shared.getTraktURL().asURL()

        if (query != nil) {
            url.appendQueryParameters(query as! [String : String])
        }

        var urlRequest = URLRequest(url: url.appendingPathComponent(path))

        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        // Common Headers
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        urlRequest.setValue(TrankApi.key.rawValue, forHTTPHeaderField: HTTPHeaderField.traktApiKey.rawValue)
        urlRequest.setValue(TrankApi.version.rawValue, forHTTPHeaderField: HTTPHeaderField.traktApiVersion.rawValue)
        
        if tokenRequired {
            urlRequest.setValue(Defaults[DefaultsKeys.accessToken], forHTTPHeaderField: HTTPHeaderField.authorization.rawValue)
        }
        
        // Parameters
        if let parameters = parameters {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }
        // Body from Encodable
        if let body = body {
            urlRequest.httpBody = body
        }
        
        return urlRequest
    }
    

    func asURL() -> URL? {
        
        do {
            var url = try ServerHelper.shared.getTraktURL().asURL()
            
            if (query != nil) {
                url.appendQueryParameters(query as! [String : String])
            }
            
            return url.appendingPathComponent(path)
        } catch ( _) {
            return nil
        }

    }
}
