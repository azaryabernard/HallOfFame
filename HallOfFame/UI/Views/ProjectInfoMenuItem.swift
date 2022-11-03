//
//  ProjectInfoMenuItem.swift
//  HallOfFame
//
//  Created by Andreas Pfurtscheller on 03.11.21.
//

import SwiftUI

struct ProjectInfoMenuItem: View {
    
    let projectInfo: ProjectInfo
    
    var body: some View {
        HStack(spacing: 12) {
            if let image = projectInfo.image {
                Image(uiImage: image)
                    .resizable()
                    .tint(Color(UIColor.label))
                    .scaledToFit()
                    .frame(width: 32, height: 32)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(projectInfo.title).font(.headline).foregroundColor(Color(UIColor.label))
                Text(projectInfo.projectKey).font(.caption).foregroundColor(Color(UIColor.secondaryLabel))
            }
        }
    }
}

struct ProjectInfoMenuItem_Previews: PreviewProvider {
    static var previews: some View {
        ProjectInfoMenuItem(
            projectInfo: ProjectInfo(
                courseKey: CourseKey("22"),
                projectConfiguration: ProjectConfiguration(key: "bsh", name: "BSH", customerKey: nil)
            )
        )
    }
}
