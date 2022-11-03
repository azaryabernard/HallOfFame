//
//  Publisher+MapOptional.swift
//  HallOfFame
//
//  Created by Andreas Pfurtscheller on 03.11.21.
//

import Foundation
import Combine

extension Publisher {
    
    func mapOptional() -> Publishers.Map<Self, Output?> {
        Publishers.Map(upstream: self, transform: { Optional($0) })
    }
    
}
