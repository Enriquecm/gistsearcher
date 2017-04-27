//
//  GSGistProcessing.swift
//  GistSearcher
//
//  Created by Enrique Melgarejo on 26/04/17.
//  Copyright © 2017 Choynowski. All rights reserved.
//

import Foundation

class GSGistProcessing {

    static func getID(fromURL url: URL?) -> String? {
        guard let url = url else { return nil }
        
        // TODO: Create some gist id validation
        let gistID = url.lastPathComponent
        return gistID
    }
}
