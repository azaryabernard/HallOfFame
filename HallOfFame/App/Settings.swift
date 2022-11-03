//
//  Settings.swift
//  HallOfFame
//
//  Created by Andreas Pfurtscheller on 03.11.21.
//

import Foundation
import Combine

extension UserDefaults {

    @objc dynamic var currentUserId: String? {
        get {
            string(forKey: "currentUserId")
        } set {
            set(newValue, forKey: "currentUserId")
        }
    }

}

class Settings: ObservableObject {
    
    @Published var currentUserId: String? = UserDefaults.standard.currentUserId {
        didSet {
            UserDefaults.standard.currentUserId = currentUserId
        }
    }

}
