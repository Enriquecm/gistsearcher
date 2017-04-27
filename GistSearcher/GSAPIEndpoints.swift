//
//  GSAPIEndpoints.swift
//  GistSearcher
//
//  Created by Enrique Melgarejo on 26/04/17.
//  Copyright © 2017 Choynowski. All rights reserved.
//

import UIKit

typealias Parameters = [String: Any]

enum GSEndpoint {
    case gistCreateComment(gistID: String) // /gists/{gistID}/comments   [POST]
    case gistComments(gistID: String)      // /gists/{gistID}/comments   [GET]
    case gistDetail(gistID: String)        // /gists/{gistID}            [GET]
}

extension GSEndpoint {
    
    var path: String {
        switch self {
        case .gistCreateComment(let gistID): return "gist/\(gistID)/comments"
        case .gistComments(let gistID):      return "gist/\(gistID)/comments"
        case .gistDetail(let gistID):        return "gist/\(gistID)"
        }
    }
}
