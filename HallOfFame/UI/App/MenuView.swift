//
//  MenuView.swift
//  HallOfFame
//
//  Created by Andreas Pfurtscheller on 03.11.21.
//

import SwiftUI

struct MenuView: View {
    
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel: ViewModel
    
    init(courseInfo: Binding<CourseInfo>) {
        _viewModel = StateObject(wrappedValue: ViewModel(courseInfo: courseInfo))
    }
        
    var body: some View {
        NavigationView {
            List(content: {
                Section {
                    Picker("app.menu.course", selection: $viewModel.courseKey) {
                        ForEach(viewModel.keys.sorted(), id: \.self) {
                            Text("app.menu.course.label".localizedWithFormat($0.key))
                        }
                    }
                }
                
                Section {
                    ForEach(viewModel.projects, id: \.key) { project in
                        Button {
                            viewModel.selectProject(project.key)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                dismiss()
                            }
                        } label: {
                            HStack {
                                ProjectInfoMenuItem(projectInfo: ProjectInfo(
                                    courseKey: viewModel.courseKey,
                                    projectConfiguration: project
                                ))
                                if project.key == viewModel.projectKey {
                                    Spacer()
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                }

                Section {
                    HStack {
                        Button("app.menu.logout", role: .destructive, action: viewModel.logout)
                    }.frame(maxWidth: .infinity)
                }
            }).navigationTitle("app.menu.title").navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(courseInfo: .constant(CourseInfo(courseKey: CourseKey("22"), projectKey: "bsh")))
    }
}
