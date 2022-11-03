//
//  Services+DI.swift
//  HallOfFame
//
//  Created by Andreas Pfurtscheller on 03.11.21.
//

import Resolver

extension Resolver {
    
    static func registerAppServices() {
        register { CourseService() }.scope(.application)
        register { ProjectService() }.scope(.application)
    }
    
}
