//
//  CourseView.swift
//  HallOfFame
//
//  Created by Nicolas Neudeck on 16.10.21.
//

import SwiftUI

struct CourseView: View {
    
    @StateObject private var viewModel: ViewModel
    
    @State private var showAppMenu = false
    
    init() {
        _viewModel = StateObject(wrappedValue: ViewModel())
    }
        
    var body: some View {
        Group {
            if let projectConfiguration = viewModel.projectConfiguration {
                ProjectView(projectInfo: ProjectInfo(
                    courseKey: viewModel.courseInfo.courseKey,
                    projectConfiguration: projectConfiguration
                ))
            } else {
                Text("project.empty")
            }
        }.onTapGesture(count: 3, perform: {
            self.showAppMenu = true
        }).onLongPressGesture(perform: {
            self.showAppMenu = true
        }).sheet(isPresented: $showAppMenu, content: {
            MenuView(courseInfo: $viewModel.courseInfo)
        })
    }
    
}

struct CourseView_Previews: PreviewProvider {
    static var previews: some View {
        CourseView()
    }
}
