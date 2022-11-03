//
//  HallOfFameApp+ViewModel.swift
//  HallOfFame
//
//  Created by Andreas Pfurtscheller on 03.11.21.
//

import Foundation
import Combine
import Resolver

extension HallOfFameApp {
    
    class ViewModel: ObservableObject {
        
        @Injected private var authRepository: AuthRepository
        
        @Published private(set) var isAuthenticated: Bool = false
        
        private var cancellables = Set<AnyCancellable>()
        
        init() {
            authRepository.$isAuthenticated.assign(to: \.isAuthenticated, on: self).store(in: &cancellables)
        }
        
    }
    
}
