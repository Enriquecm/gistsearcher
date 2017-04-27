//
//  GSGistDetailViewModel.swift
//  GistSearcher
//
//  Created by Enrique Melgarejo on 26/04/17.
//  Copyright © 2017 Choynowski. All rights reserved.
//

import UIKit

class GSGistDetailViewModel: NSObject {

    func process(gistURL url: URL?) {
        
        let gistID = GSGistProcessing.getID(fromURL: url)
        
        
    }
}
