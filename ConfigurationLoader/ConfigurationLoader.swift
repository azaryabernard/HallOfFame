//
//  ConfigurationLoader.swift
//  HallOfFame
//
//  Created by Andreas Pfurtscheller on 28.04.22.
//

import os
import Foundation

@main
struct ConfigurationLoader {
    
    struct Environment {
        let srcRoot: String
        let derivedFileDir: String
        let token: String
        
        init() throws {
            if let srcRoot = ProcessInfo.processInfo.environment["SRCROOT"] {
                self.srcRoot = srcRoot
            } else {
                throw ConfigurationLoaderError.missingEnv("SRCROOT")
            }
            
            if let derivedFileDir = ProcessInfo.processInfo.environment["DERIVED_FILE_DIR"] {
                self.derivedFileDir = derivedFileDir
            } else {
                throw ConfigurationLoaderError.missingEnv("DERIVED_FILE_DIR")
            }
            
            if let token = ProcessInfo.processInfo.environment["CONFLUENCE_TOKEN"] {
                self.token = token
            } else {
                throw ConfigurationLoaderError.missingEnv("CONFLUENCE_TOKEN")
            }
        }
    }
    
    enum MemberType {
        case developer
        case coach
        case projectLead
        case programManagement
        
        var key: String {
            switch self {
            case .coach: return "coaches"
            case .developer: return "students"
            case .projectLead: return "pl"
            case .programManagement: return "pm"
            }
        }
    }
    
    enum ConfigurationLoaderError: Error {
        case invalidUrl
        case invalidResponse(URLResponse)
        case missingEnv(String)
        case artificialError
    }
    
    let environment: Environment
    let baseUrl = URL(string: "https://confluence.ase.in.tum.de/rest/api")!
    
    static func main() async throws {        
        let environment = try Environment()
        
        let configurationLoader = ConfigurationLoader(environment: environment)
        
        try await configurationLoader.run()
    }
    
    func run() async throws {
        print("Configuration loader started.")
        
        print("Initializing configuration from Configuration.json")
        
        let configuration = try loadConfiguration()
        
        print("Loading members for all courses.")
        
        let remoteConfiguration = try await mapConfiguration(configuration)
        
        print("Writing configuration to Data.json")
                
        let configurationData = try JSONEncoder().encode(remoteConfiguration)
                
        let configurationUrl = URL(fileURLWithPath: "\(environment.derivedFileDir)/Data.json")
        
        try configurationData.write(to: configurationUrl)
        
        print("Wrote configuration to \(configurationUrl).")
        
        print("Done.")
    }
    
    func loadConfiguration() throws -> Configuration {
        
        guard let projectDir = ProcessInfo.processInfo.environment["SRCROOT"] else {
            throw ConfigurationLoaderError.missingEnv("SRCROOT")
        }
        
        let data = try Data(contentsOf: URL(fileURLWithPath: "\(projectDir)/ConfigurationLoader/Configuration.json"))
        
        return try JSONDecoder().decode(Configuration.self, from: data)
    }
    
    func mapConfiguration(
        _ configuration: Configuration
    ) async throws -> Configuration {
        Configuration(
            courseList: try await mapCourses(configuration.courseList),
            customers: configuration.customers
        )
    }
    
    func mapCourses(
        _ courses: [CourseConfiguration]
    ) async throws -> [CourseConfiguration] {
        try await withThrowingTaskGroup(of: CourseConfiguration.self) { group in
            for course in courses {
                group.addTask {
                    try await mapCourse(course)
                }
            }
            
            return try await group.reduce(into: [CourseConfiguration](), { $0.append($1) })
        }
    }
    
    func mapCourse(
        _ course: CourseConfiguration
    ) async throws -> CourseConfiguration {
        async let coaches = loadMembers(key: course.key, type: .coach)
        async let projectLeads = loadMembers(key: course.key, type: .projectLead)
        async let programManagement = loadMembers(key: course.key, type: .programManagement)
                
        return await CourseConfiguration(
            key: course.key,
            projects: course.projects,
            coaches: try coaches,
            projectLeads: try projectLeads,
            management: try programManagement
        )
    }
    
    func loadMembers(key: CourseKey, type: MemberType) async throws -> [String] {
        let membersRequest = try request("group/ios\(key.key)\(type.key)/member")
        
        let (data, response) = try await URLSession.shared.data(for: membersRequest)
        
        guard let response = response as? HTTPURLResponse, (200...299) ~= response.statusCode else {
            throw ConfigurationLoaderError.invalidResponse(response)
        }
        
        let members = try JSONDecoder().decode(PaginatedResponse<ConfluenceUser>.self, from: data)
        
        return members.results.map({ $0.username })
    }
    
    func request(_ path: String, query: [URLQueryItem] = []) throws -> URLRequest {
        var url = URLComponents(url: baseUrl.appendingPathComponent(path), resolvingAgainstBaseURL: false)
        url?.queryItems = query
        
        guard let url = url?.url else { throw ConfigurationLoaderError.invalidUrl }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(environment.token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    struct ConfluenceGroup: Decodable {
        let name: String
    }
    
    struct ConfluenceUser: Decodable {
        let username: String
    }
    
    struct PaginatedResponse<Result>: Decodable where Result: Decodable {
        let results: [Result]
    }
    
}
