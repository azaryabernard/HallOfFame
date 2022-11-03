//
//  VisualEffectView.swift
//  HallOfFame
//
//  Created by Andreas Pfurtscheller on 03.11.21.
//

import Foundation
import SwiftUI

struct VisualEffectView: UIViewRepresentable {
    
    var effect: UIVisualEffect?
    
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView {
        UIVisualEffectView()
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) {
        uiView.effect = effect
    }
}
