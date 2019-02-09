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

enum TraktEndPoint: APIConfiguration {
    
    case postLogin(email: String, password: String?)
    
    var method: HTTPMethod {
        switch self {
        case .postLogin:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .postLogin:
            return "/login"
        }
    }
    
    var parameters: Parameters? {
        switch self {
//        case .postLogin(let email, let password):
//            if password != nil {
//                return [K.AuthParameterKey.email: email, K.AuthParameterKey.password: password!]
//            } else {
//                return [K.AuthParameterKey.email: email, K.AuthParameterKey.passwordHash: passwordHash!]
//            }
        default:
            return nil
        }
    }
    
    var pathWithQuery: (path: String, parameters: Parameters)? {
        switch self {

        default:
            return nil
        }
    }
    
    var body: Data? {
//        let encoder = JSONEncoder()
        switch self {
//        case .postSignUp(let signUpBody):
//            return try! encoder.encode(signUpBody)
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
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = try ServerHelper.shared.getTraktURL().asURL()
        //if (pathWithQuery != nil) {
            //url.appendQueryParameters(pathWithQuery!.parameters as! [String : String])
        //}
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        // Common Headers
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        urlRequest.setValue(Defaults[DefaultsKeys.sessionToken], forHTTPHeaderField: HTTPHeaderField.acceptToken.rawValue)
        
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
    

}
