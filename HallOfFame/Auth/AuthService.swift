//
//  AuthService.swift
//  HallOfFame
//
//  Created by Andreas Pfurtscheller on 03.11.21.
//

import Foundation
import Combine
import Resolver

class AuthService {
    
    @Injected private var api: Api
    @Injected private var authRepository: AuthRepository
    
    @discardableResult
    func login(username: String, password: String) async throws -> User {
        let user = try await api.auth(username: username, password: password)
        DispatchQueue.main.async {
            // If the request succeeds, update the auth state in the repository
            self.authRepository.login(user: user, password: password)
        }
        return user
    }
    
    func logout() {
        authRepository.logout()
    }
    
}
