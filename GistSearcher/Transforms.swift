//
//  Transforms.swift
//  GistSearcher
//
//  Created by Enrique Melgarejo on 26/04/17.
//  Copyright © 2017 Choynowski. All rights reserved.
//

import Foundation
import ObjectMapper

struct Transforms {
    
    static let numberToStringTransform = TransformOf<String, Int64>(
        fromJSON: { $0.flatMap{String($0)} },
        toJSON: { $0.flatMap{Int64($0)} })
    
    static let longDateTransform = DateFormatterTransform(dateFormatter: DateHelper.sharedInstance.longDateFormatter)
    
    static let stringToDateTransform = TransformOf<Date, String> (
        fromJSON: {
            $0.flatMap{
                return Transforms.longDateTransform.transformFromJSON($0)
            }
    },
        toJSON: {
            $0.flatMap {
                Transforms.longDateTransform.transformToJSON($0) ?? Transforms.longDateTransform.transformToJSON($0)
            }
    })
}
