//
//  Publisher+Erase.swift
//  HallOfFame
//
//  Created by Andreas Pfurtscheller on 03.11.21.
//

import Foundation
import Combine

extension Publisher {
    
    func erase() -> Publishers.Map<Self, Void> {
        Publishers.Map(upstream: self, transform: { _ in () })
    }
    
}
