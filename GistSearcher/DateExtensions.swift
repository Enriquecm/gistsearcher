//
//  DateExtensions.swift
//  GistSearcher
//
//  Created by Enrique Melgarejo on 26/04/17.
//  Copyright © 2017 Choynowski. All rights reserved.
//

import Foundation

extension Date {
    
    func createdAtDateFormat() -> String {
        let dateFormatter = DateHelper.sharedInstance.createdAtDateFormatter
        return dateFormatter.string(from: self)
    }
    
    func shortDateFormat() -> String {
        let dateFormatter = DateHelper.sharedInstance.shortDateFormatter
        return dateFormatter.string(from: self)
    }
}
