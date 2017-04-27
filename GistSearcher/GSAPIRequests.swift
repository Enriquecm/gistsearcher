//
//  GSAPIRequests.swift
//  GistSearcher
//
//  Created by Enrique Melgarejo on 26/04/17.
//  Copyright © 2017 Choynowski. All rights reserved.
//

import Foundation

struct GSAPIRequests {
    
    static func searchGist(for gistId: String, completion: NetworkResponse<GSGist>) {
        
        let endpoint = GSEndpoint.gistDetail(gistID: gistId)
    
        GSAPIProvider.GET(withEndPoint: endpoint.path) { (gist: GSGist?, error) in
            completion?(gist, error)
        }
    }
    
    static func listComments(for gistId: String, completion: NetworkResponse<GSComment>) {
        
        let endpoint = GSEndpoint.gistComments(gistID: gistId)
        
        GSAPIProvider.GET(withEndPoint: endpoint.path) { (comments: GSComment?, error) in
            completion?(comments, error)
        }
    }
    
    static func writeComment(comment: String, for gistID: String, completion: NetworkResponse<GSComment>) {
        
        let endpoint = GSEndpoint.gistCreateComment(gistID: gistID)
        
        let params = [
            "body": comment
        ] as Parameters
        
        GSAPIProvider.POST(withEndPoint: endpoint.path, andParams: params) { (comments: GSComment?, error) in
            completion?(comments, error)
        }
    }
}
