//
//  Auth+DI.swift
//  HallOfFame
//
//  Created by Andreas Pfurtscheller on 03.11.21.
//

import Foundation
import Resolver

extension Resolver {
    
    static func registerAuthServices() {
        register { AuthRepository() }.scope(.application)
        register { AuthService() }.scope(.application)
    }
    
}
