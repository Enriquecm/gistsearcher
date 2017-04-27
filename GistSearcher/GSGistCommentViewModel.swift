//
//  GSGistCommentViewModel.swift
//  GistSearcher
//
//  Created by Enrique Melgarejo on 27/04/17.
//  Copyright © 2017 Choynowski. All rights reserved.
//

import UIKit

class GSGistCommentViewModel: NSObject {

    func saveComment(comment: String?, forGistID gistID: String?, completion: NetworkResponse<GSComment>) {
        
        guard let comment = comment, let gistID = gistID else {
            completion?(nil, nil)
            return
        }
        
        GSAPIRequests.writeComment(comment: comment, for: gistID, completion: completion)
    }
}
