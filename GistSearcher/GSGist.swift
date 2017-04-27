//
//  GSGist.swift
//  GistSearcher
//
//  Created by Enrique Melgarejo on 26/04/17.
//  Copyright © 2017 Choynowski. All rights reserved.
//

import Foundation
import ObjectMapper

class GSGist: Mappable {
    
    var url: String?
    var gistID: String?
    var files: [String : GSFile]?
    var ownerUser: Double?
    var commentsCount: Int?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        url           <- map["url"]
        gistID        <- map["id"]
        files         <- map["files"]
        ownerUser     <- map["owner"]
        commentsCount <- map["comments"]
    }
}
