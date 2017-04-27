//
//  GSGistDetailViewModel.swift
//  GistSearcher
//
//  Created by Enrique Melgarejo on 26/04/17.
//  Copyright © 2017 Choynowski. All rights reserved.
//

import UIKit

class GSGistDetailViewModel: NSObject {

    var gist: GSGist?
    
    var gistFiles: [GSFile] {
        return gist?.files?.values.map({$0}) ?? []
    }
    
    func process(gistURL url: URL?, completion: NetworkResponse<GSGist>) {
        
        guard let gistID = GSGistProcessing.getID(fromURL: url) else { return }
        
        GSAPIRequests.searchGist(for: gistID) { [weak self] (gist, error) in
            self?.gist = gist
            completion?(gist, error)
        }
    }
}
