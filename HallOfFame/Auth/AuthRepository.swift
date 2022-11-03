//
//  AuthRepository.swift
//  HallOfFame
//
//  Created by Andreas Pfurtscheller on 03.11.21.
//

import Foundation
import Combine
import KeychainAccess
import Resolver

class AuthRepository: ObservableObject {
    
    @Injected private var settings: Settings
    
    private let keychain = Keychain(service: Bundle.main.bundleIdentifier!)
    
    @Published private(set) var isAuthenticated: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    private(set) var token: String? {
        get { keychain["token"] }
        set { keychain["token"] = newValue }
    }
    
    init() {
        settings.$currentUserId
            .map({ $0 != nil })
            .assign(to: \.isAuthenticated, on: self)
            .store(in: &cancellables)
    }
    
    func login(user: User, password: String) {
        // Generate the basic auth token
        let basicAuthToken = "\(user.username):\(password)".base64Encoded
        // Store the token to the keychain
        token = basicAuthToken
        // Set basic auth in shared url session
        URLSession.shared.configuration.httpAdditionalHeaders = [
            "Authorization": "Basic \(basicAuthToken)"
        ]
        // Finally, set the user id in settings
        settings.currentUserId = user.key
    }
    
    func logout() {
        // First, delete the token
        token = nil
        // Then, delete the current user id in settings
        settings.currentUserId = nil
        // Unset basic auth in shared url session
        URLSession.shared.configuration.httpAdditionalHeaders?["Authorization"] = nil
    }
    
}
