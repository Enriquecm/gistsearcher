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
        guard let user = GSUserCoordinator.shared.login,
            let pass = GSUserCoordinator.shared.password else { return }
        
        let credentialData = "\(user):\(pass)".data(using: .utf8)
        let base64Credentials = credentialData?.base64EncodedString(options: []) ?? ""
        let headers = [
            "Authorization": "Basic \(base64Credentials)",
            "Content-Type":"application/json"
        ]
        
        do {
            var urlRequest = try URLRequest(url: GSAPIParameters.githubURL + endPoint, method: .post, headers: headers )
            var json: String?
            if let params = params, let data = try? JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted) {
                json = String(data: data, encoding: .utf8)
            }
            urlRequest.httpBody = json?.data(using: .utf8)
            Alamofire.request(urlRequest)
                .validate()
                .responseObject { (response: DataResponse<T>) in
                    
                    switch response.result {
                    case .success(let response):
                        completion?(response, nil)
                    case .failure(let error):
                        completion?(nil, error)
                    }
            }
        } catch {
            debugPrint("Fail to create a comment")
            let errorTemp = NSError(domain:"Gist Searcher", code:1, userInfo:nil)
            completion?(nil, errorTemp as Error)
        }
    }
}
