//
//  DateHelper.swift
//  GistSearcher
//
//  Created by Enrique Melgarejo on 26/04/17.
//  Copyright © 2017 Choynowski. All rights reserved.
//

import Foundation

class DateHelper {
    
    static let sharedInstance = DateHelper()
    
    lazy var calendar: Calendar = {
        var cal = Calendar.current
        cal.locale = DateHelper.sharedInstance.locale
        cal.timeZone = TimeZone.current
        return cal
    }()
    
    let locale = Locale(identifier: "pt_BR_POSIX")
    
    lazy var createdAtDateFormatter: DateFormatter = {
        let format = DateFormatter()
        format.calendar = DateHelper.sharedInstance.calendar
        format.dateFormat = "dd/MM/yyyy - HH:mm"
        return format
    }()
    
    lazy var shortDateFormatter: DateFormatter = {
        let format = DateFormatter()
        format.calendar = DateHelper.sharedInstance.calendar
        format.dateFormat = "dd/MM/yyyy"
        return format
    }()
    
    lazy var longDateFormatter: DateFormatter = {
        let format = DateFormatter()
        format.calendar = DateHelper.sharedInstance.calendar
        format.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return format
    }()
}
