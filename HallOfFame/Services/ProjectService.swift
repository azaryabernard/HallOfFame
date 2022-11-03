//
//  ProjectService.swift
//  HallOfFame
//
//  Created by Andreas Pfurtscheller on 03.11.21.
//

import Foundation
import Combine
import Resolver

class ProjectService {
    
    enum ProjectServiceError: Swift.Error {
        case invalidCourseYear
        case invalidProjectKey
        case invalidCustomer
    }
    
    @Injected private var api: Api
    @Injected private var courseService: CourseService
    
    private var projectCache: [String: Project] = [:]
    
    func fetchProject(projectInfo: ProjectInfo) async throws -> Project {
        guard let course = courseService[projectInfo.courseKey] else {
            throw ProjectServiceError.invalidCourseYear
        }
        
        guard let projectConfiguration = course.projects.first(where: { $0.key == projectInfo.projectKey }) else {
            throw ProjectServiceError.invalidProjectKey
        }
        
        let projectIdentifier = projectInfo.identifier
        
        if let cachedProject = projectCache[projectIdentifier] {
            // If the project was found in our memory cache,
            // use it instead of sending another series of requests.
            return cachedProject
        }
        
        guard let customer = courseService.customer(for: projectConfiguration.customer) else {
            throw ProjectServiceError.invalidCustomer
        }
        
        async let developers = api.members(groupId: projectIdentifier)
        async let customers = api.members(groupId: "\(projectIdentifier)-customers")
        async let management = api.members(groupId: "\(projectIdentifier)-mgmt")
        
        let project = await Project(
            key: projectConfiguration.key,
            identifier: projectIdentifier,
            title: projectConfiguration.name ?? "Team \(customer.name)",
            image: projectInfo.image,
            customer: customer,
            customers: try customers,
            projectLeads: try management.filter({ course.projectLeads.contains($0.username) }),
            coaches: try management.filter({ course.coaches.contains($0.username) }),
            developers: try developers
        )
        
        self.projectCache[projectIdentifier] = project
        
        return project
    }
    
}
