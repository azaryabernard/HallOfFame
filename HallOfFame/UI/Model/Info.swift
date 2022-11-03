//
//  Info.swift
//  HallOfFame
//
//  Created by Andreas Pfurtscheller on 05.05.22.
//

import Foundation
import UIKit

struct CourseInfo: Equatable {
    let courseKey: CourseKey
    let projectKey: String?
}

struct ProjectInfo: Equatable {
    let courseKey: CourseKey
    let projectConfiguration: ProjectConfiguration
    
    var identifier: String {
        "ios\(courseKey)\(projectConfiguration.key)"
    }
    
    var title: String {
        projectConfiguration.name ?? "ios\(courseKey)\(projectConfiguration.key)".uppercased()
    }
    
    var projectKey: String {
        projectConfiguration.key
    }
    
    var image: UIImage? {
        guard let image = UIImage(named: "Project/ios\(courseKey)\(projectConfiguration.key)/Logo") else {
            return UIImage(named: "Customer/\(projectConfiguration.customer)/Logo")
        }
        
        return image
    }
}
