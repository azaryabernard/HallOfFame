//
//  LoginView+ViewModel.swift
//  HallOfFame
//
//  Created by Andreas Pfurtscheller on 03.11.21.
//

import Foundation
import Combine
import Resolver
import UIKit

extension LoginView {
    
    @MainActor class ViewModel: ObservableObject {
        
        @Injected private var authService: AuthService
        @Injected private var environment: AppEnvironment
        
        @Published var isLoading: Bool = false
        @Published var error: Error?
        
        @Published var username: String = ""
        @Published var password: String = ""
        
        private var cancellables = Set<AnyCancellable>()
        
        func login() async {
            isLoading = true
            defer { isLoading = false }
            
            do {
                try await authService.login(username: username, password: password)
            } catch {
                self.error = error
            }
        }
        
        func goToConfluence() {            
            UIApplication.shared.open(environment.baseUrl)
        }
        
    }
    
}
