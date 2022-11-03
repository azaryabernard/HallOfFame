//
//  ProjectView+ViewModel.swift
//  HallOfFame
//
//  Created by Andreas Pfurtscheller on 03.11.21.
//

import Foundation
import Resolver

extension ProjectView {
    
    @MainActor class ViewModel: ObservableObject {
        
        @Injected private var projectService: ProjectService
        
        @Published private(set) var project: Result<Project, Swift.Error>?
        
        let projectInfo: ProjectInfo
        
        init(projectInfo: ProjectInfo) {
            self.projectInfo = projectInfo
        }
        
        func load() async {
            do {
                project = .success(try await projectService.fetchProject(projectInfo: projectInfo))
            } catch {
                project = .failure(error)
            }
        }
        
    }
    
}
