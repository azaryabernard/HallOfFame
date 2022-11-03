//
//  CourseView+ViewModel.swift
//  HallOfFame
//
//  Created by Andreas Pfurtscheller on 03.11.21.
//

import Foundation
import Combine
import Resolver
import SwiftUI

extension CourseView {
    
    @MainActor class ViewModel: ObservableObject {
        
        @Injected private var courseService: CourseService
        
        @Published var courseInfo: CourseInfo
        
        private var cancellables = Set<AnyCancellable>()
        
        init() {
            courseInfo = CourseInfo(
                courseKey: CourseKey(String(String(Calendar.current.component(.year, from: Date())).suffix(2))),
                projectKey: nil
            )
            
            if let latestKey = courseService.keys.max() {
                courseInfo = CourseInfo(courseKey: latestKey, projectKey: nil)
            }
                        
            // Listen for the `DeviceDidShake` event
            NotificationCenter.default.publisher(for: .DeviceDidShake)
                // Listen to notifications on a different queue
                .subscribe(on: DispatchQueue.global(qos: .userInitiated))
                // Erase the value of the upstream publisher to `Void`
                .erase()
                // Prepend one element in order as an initial trigger
                .prepend(())
                // Map a `Void` element to a random project key, if any
                .map({ [unowned self] in self.randomProjectCourse })
                // Assign the value on the main queue
                .receive(on: DispatchQueue.main)
                // Assign the project key
                .assign(to: \.courseInfo, on: self)
                .store(in: &cancellables)
        }

        private var randomProjectCourse: CourseInfo {
            CourseInfo(
                courseKey: courseInfo.courseKey,
                projectKey: randomProjectKey
            )
        }
        
        private var randomProjectKey: String? {
            var projectKey: String? = courseInfo.projectKey
            repeat {
                projectKey = courseService.projectKeys(forCourseKey: courseInfo.courseKey).randomElement()
            } while(projectKey == courseInfo.projectKey)
            return projectKey
        }
        
        var projectConfiguration: ProjectConfiguration? {
            courseInfo.projectKey.flatMap({
                courseService.project(forCourseKey: courseInfo.courseKey, projectKey: $0)
            })
        }
        
    }
    
}
