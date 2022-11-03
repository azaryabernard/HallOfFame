//
//  Configuration.swift
//  HallOfFame
//
//  Created by Andreas Pfurtscheller on 28.04.22.
//

import Foundation

struct CourseKey: Codable, Hashable, Comparable, Identifiable, CustomStringConvertible {
    let key: String
    var isWinterTerm: Bool { key.count > 2 }
    var isSummerTerm: Bool { !isWinterTerm }
    
    init(_ key: String) {
        self.key = key
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.key = try container.decode(String.self)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(key)
    }
    
    var description: String { key }
    
    var id: String { key }
    
    static func < (lhs: CourseKey, rhs: CourseKey) -> Bool {
        guard lhs.key != rhs.key else {
            return false
        }
        
        return lhs.key.suffix(2) <= rhs.key.prefix(2)
    }
}

struct Configuration: Codable {
    var courseList: [CourseConfiguration] = []
    var customers: [CustomerConfiguration] = []
    
    enum CodingKeys: String, CodingKey {
        case courseList = "courses", customers
    }
    
    var courses: [CourseKey: CourseConfiguration] {
        courseList.reduce(into: [CourseKey: CourseConfiguration](), { $0[$1.key] = $1 })
    }
}

struct CourseConfiguration: Codable {
    let key: CourseKey
    let projects: [ProjectConfiguration]
    let coaches: [String]
    let projectLeads: [String]
    let management: [String]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.key = try container.decode(CourseKey.self, forKey: .key)
        self.projects = (try? container.decode([ProjectConfiguration].self, forKey: .projects)) ?? []
        self.coaches = (try? container.decode([String].self, forKey: .coaches)) ?? []
        self.projectLeads = (try? container.decode([String].self, forKey: .projectLeads)) ?? []
        self.management = (try? container.decode([String].self, forKey: .management)) ?? []
    }
    
    internal init(key: CourseKey, projects: [ProjectConfiguration], coaches: [String], projectLeads: [String], management: [String]) {
        self.key = key
        self.projects = projects
        self.coaches = coaches
        self.projectLeads = projectLeads
        self.management = management
    }
}

struct ProjectConfiguration: Codable, Equatable {
    let key: String
    let name: String?
    let customerKey: String?
    
    var customer: String {
        customerKey ?? key
    }
}

struct CustomerConfiguration: Codable {
    let key: String
    let name: String
    let longName: String?
}
