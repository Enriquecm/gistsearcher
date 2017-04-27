//
//  GSFile.swift
//  GistSearcher
//
//  Created by Enrique Melgarejo on 26/04/17.
//  Copyright © 2017 Choynowski. All rights reserved.
//

import UIKit
import ObjectMapper

class GSFile: Mappable {
    
    var name: String?
    var language: String?
    var content: String?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        name     <- map["filename"]
        language <- map["language"]
        content  <- map["content"]
    }
}
