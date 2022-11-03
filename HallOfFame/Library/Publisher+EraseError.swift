//
//  Publisher+EraseError.swift
//  HallOfFame
//
//  Created by Andreas Pfurtscheller on 03.11.21.
//

import Foundation
import Combine

extension Publisher {
    
    func eraseError() -> Publishers.MapError<Self, Error> {
        mapError({ error -> Error in error })
    }
    
}
