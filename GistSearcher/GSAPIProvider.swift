//
//  GSAPIProvider.swift
//  GistSearcher
//
//  Created by Enrique Melgarejo on 26/04/17.
//  Copyright © 2017 Choynowski. All rights reserved.
//

import Alamofire
import AlamofireObjectMapper
import ObjectMapper

typealias NetworkResponse<T> = ((T?, Error?) -> Void)?

struct GSAPIParameters {
    static let githubURL = "https://api.github.com/"
}

struct GSAPIProvider {
    
    // MARK: Web Service GET request
    static func GET<T: Mappable>(withEndPoint endPoint: String, andParams params: Parameters? = nil, completion: NetworkResponse<T>) {
        
        Alamofire.request(GSAPIParameters.githubURL + endPoint, parameters: params)
            .validate()
            .responseObject { (response: DataResponse<T>) in
                
                switch response.result {
                case .success(let response):
                    completion?(response, nil)
                case .failure(let error):
                    completion?(nil, error)
                }
        }
    }
    
    static func POST<T: Mappable>(withEndPoint endPoint: String, andParams params: Parameters? = nil, completion: NetworkResponse<T>) {
        
        Alamofire.request(GSAPIParameters.githubURL + endPoint, method: .post, parameters: params)
            .validate()
            .responseObject { (response: DataResponse<T>) in
            
            switch response.result {
            case .success(let response):
                completion?(response, nil)
            case .failure(let error):
                completion?(nil, error)
            }
        }
    }
}
