//
//  GSComment.swift
//  GistSearcher
//
//  Created by Enrique Melgarejo on 26/04/17.
//  Copyright © 2017 Choynowski. All rights reserved.
//

import UIKit
import ObjectMapper

class GSComment: Mappable {
    
    var url       : String?
    var commentID : String?
    var body      : String?
    var createdAt : Date?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        url     <- map["url"]
        commentID <- map["id"]
        body  <- map["body"]
        createdAt <- (map["created_at"], Transforms.stringToDateTransform)
    }
}
