//
//  Api.swift
//  HallOfFame
//
//  Created by Andreas Pfurtscheller on 03.11.21.
//

import Foundation
import Resolver

enum ApiError: Error {
    case invalidUrl
    case invalidResponse(URLResponse)
}

struct Api {
    
    @Injected private var environment: AppEnvironment
    @Injected private var authRepository: AuthRepository
    
    var apiUrl: URL {
        environment.baseUrl.appendingPathComponent("rest").appendingPathComponent("api")
    }
    
    func url(forImageResource resource: ImageResource) -> URL? {
        environment.baseUrl.appendingPathComponent(resource.path)
    }
    
    func auth(username: String, password: String) async throws -> User {
        let token = "\(username):\(password)".base64Encoded
        return try await request("user/current", header: [
            ("Authorization", "Basic \(token)")
        ])
    }
    
    func members(groupId: String) async throws -> [User] {
        let response: PaginatedResponse<User> = try await request("group/\(groupId)/member")
        return response.results
    }
    
    func currentUser() async throws -> User {
        try await request("user/current")
    }
    
    func user(username: String) async throws -> User {
        try await request("user", query: [URLQueryItem(name: "username", value: username)])
    }
    
    private func request<Result>(
        _ path: String, query: [URLQueryItem] = [], header: [(String, String)] = []
    ) async throws -> Result where Result: Decodable {
        var url = URLComponents(
            url: apiUrl.appendingPathComponent(path),
            resolvingAgainstBaseURL: false
        )
        
        url?.queryItems = query
        
        guard let url = url?.url else { throw ApiError.invalidUrl }
        
        var request = URLRequest(url: url)
        
        if let token = authRepository.token {
            request.setValue("Basic \(token)", forHTTPHeaderField: "Authorization")
        }
        
        for (field, value) in header {
            request.setValue(value, forHTTPHeaderField: field)
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse, (200...299) ~= response.statusCode else {
            throw ApiError.invalidResponse(response)
        }
                
        return try JSONDecoder().decode(Result.self, from: data)
    }
    
    struct PaginatedResponse<Result>: Decodable where Result: Decodable {
        let results: [Result]
    }
    
}
