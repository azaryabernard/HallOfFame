//
//  CourseService.swift
//  HallOfFame
//
//  Created by Andreas Pfurtscheller on 03.11.21.
//

import Foundation

class CourseService {
    
    private let decoder = JSONDecoder()
    
    private var configuration = Configuration()
    
    init() {
        loadData()
    }
    
    subscript(_ courseKey: CourseKey) -> CourseConfiguration? {
        configuration.courses[courseKey]
    }
    
    var courses: [CourseKey: CourseConfiguration] {
        configuration.courses
    }
    
    var keys: [CourseKey] {
        configuration.courses.map({ $0.key })
    }
    
    func projects(forCourseKey courseKey: CourseKey) -> [ProjectConfiguration] {
        self[courseKey]?.projects ?? []
    }
    
    func project(forCourseKey courseKey: CourseKey, projectKey: String) -> ProjectConfiguration? {
        projects(forCourseKey: courseKey).first { $0.key == projectKey }
    }
    
    func projectKeys(forCourseKey courseKey: CourseKey) -> [String] {
        projects(forCourseKey: courseKey).map({ $0.key })
    }
    
    func customer(for key: String) -> Customer? {
        guard let customerConfiguration = configuration.customers.first(where: { $0.key == key }) else {
            return nil
        }
        
        return Customer(
            key: customerConfiguration.key,
            name: customerConfiguration.name,
            longName: customerConfiguration.longName
        )
    }
    
    /// Loads the course data from Data.json file.
    /// If anything fails in here, it is a programmer error.
    /// Therefore, it is safe to throw fatal errors.
    private func loadData() {
        guard let url = Bundle.main.url(forResource: "Data", withExtension: "json") else {
            fatalError("The required Data.json is missing")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Could not read Data.json")
        }
        
        guard let configuration = try? decoder.decode(Configuration.self, from: data) else {
            fatalError("Failed decoding Data.json")
        }
        
        self.configuration = configuration
    }
    
}
