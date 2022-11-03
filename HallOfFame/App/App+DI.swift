//
//  App+DI.swift
//  HallOfFame
//
//  Created by Andreas Pfurtscheller on 03.11.21.
//

import Foundation
import Resolver

extension Resolver: ResolverRegistering {
    
    public static func registerAllServices() {
        registerCoreServices()
        registerAuthServices()
        registerAppServices()
    }
    
    static func registerCoreServices() {
        register { AppEnvironment() }.scope(.application)
        register { Settings() }.scope(.application)
        register { Api() }.scope(.application)
    }
    
}
