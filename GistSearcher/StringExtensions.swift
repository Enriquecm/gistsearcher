//
//  StringExtensions.swift
//  GistSearcher
//
//  Created by Enrique Melgarejo on 26/04/17.
//  Copyright © 2017 Choynowski. All rights reserved.
//

import Foundation

extension String {
    
    func isValidURL() -> Bool {
        
        let types: NSTextCheckingResult.CheckingType = [.link]
        guard let detector = try? NSDataDetector(types: types.rawValue),
            self.characters.count > 0 else { return false }
        
        if detector.numberOfMatches(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count)) > 0 {
            return true
        }
        return false
    }
}
