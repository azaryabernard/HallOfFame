//
//  ProjectView.swift
//  HallOfFame
//
//  Created by Andreas Pfurtscheller on 03.11.21.
//

import SwiftUI

struct ProjectView: View {
    
    @ObservedObject private var viewModel: ViewModel
        
    init(projectInfo: ProjectInfo) {
        viewModel = ViewModel(projectInfo: projectInfo)
    }
    
    var body: some View {
        Group {
            if case let .success(project) = viewModel.project {
                ProjectContentView(project: project)
            } else if case let .failure(error) = viewModel.project {
                errorView(error: error)
            } else {
                loadingView
            }
        }.task(id: viewModel.projectInfo) {
            await viewModel.load()
        }
    }
    
    private func errorView(error: Error) -> some View {
        VStack(alignment: .center, spacing: 8) {
            Text("project.load.error")
            Button(action: {
                Task {
                    await viewModel.load()
                }
            }, label: {
                HStack(spacing: 2) {
                    Image(systemName: "arrow.clockwise")
                    Text("project.load.reload")
                }
            }).disabled(viewModel.project == nil)
        }.frame(maxWidth: .infinity, alignment: .center)
    }
    
    var loadingView: some View {
        ProgressView().progressViewStyle(.circular).frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }

}

struct ProjectView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectView(
            projectInfo: ProjectInfo(
                courseKey: CourseKey("22"),
                projectConfiguration: ProjectConfiguration(
                    key: "sz",
                    name: "AutoPlay",
                    customerKey: nil
                )
            )
        )
    }
}
