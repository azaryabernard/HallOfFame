//
//  HallOfFameApp.swift
//  HallOfFame
//
//  Created by Nicolas Neudeck on 16.10.21.
//

import SwiftUI

@main
struct HallOfFameApp: App {
    
    @StateObject private var viewModel = ViewModel()
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                GeometryReader { geometry in
                    if viewModel.isAuthenticated {
                        CourseView()
                    } else {
                        LoginView()
                    }
                    VisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
                        .edgesIgnoringSafeArea(.top)
                        .frame(width: geometry.size.width, height: 0)
                }
            }
        }
    }

}
