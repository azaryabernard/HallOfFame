//
//  MenuView+ViewModel.swift
//  HallOfFame
//
//  Created by Andreas Pfurtscheller on 03.11.21.
//

import Foundation
import Resolver
import SwiftUI

extension MenuView {
    
    class ViewModel: ObservableObject {
        
        @Injected private var authService: AuthService
        @Injected private var courseService: CourseService
        
        @Published var courseKey: CourseKey
        @Published var projectKey: String?
        
        @Binding var courseInfo: CourseInfo
        
        init(courseInfo: Binding<CourseInfo>) {
            _courseInfo = courseInfo
            courseKey = courseInfo.wrappedValue.courseKey
            projectKey = courseInfo.wrappedValue.projectKey
        }
        
        var keys: [CourseKey] {
            courseService.keys
        }
        
        var projects: [ProjectConfiguration] {
            courseService.projects(forCourseKey: courseKey)
        }
        
        func selectProject(_ key: String) {
            projectKey = key
            courseInfo = CourseInfo(courseKey: courseKey, projectKey: key)
        }
        
        func logout() {
            authService.logout()
        }
        
    }
    
}
