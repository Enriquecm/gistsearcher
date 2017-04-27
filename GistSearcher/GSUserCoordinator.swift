//
//  GSUserCoordinator.swift
//  GistSearcher
//
//  Created by Enrique Melgarejo on 27/04/17.
//  Copyright © 2017 Choynowski. All rights reserved.
//

import UIKit

class GSUserCoordinator: NSObject {

    var login: String?
    var password: String?
    
    static let shared = GSUserCoordinator()
    
    func saveUser(login: String?, andPassword password: String?) {
        self.login = login
        self.password = password
    }
    
    func hasCredentials() -> Bool {
        return (login != nil && password != nil)
    }
    
    func clear() {
        login = nil
        password = nil
    }
}
