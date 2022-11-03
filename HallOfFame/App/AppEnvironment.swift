//
//  AppEnvironment.swift
//  HallOfFame
//
//  Created by Andreas Pfurtscheller on 03.11.21.
//

import Foundation

public struct AppEnvironment {
    
    private var data: [String: Any] = [:]
    
    init(from file: String = "Info", in bundle: Bundle = Bundle.main) {
        guard let path = bundle.path(forResource: file, ofType: "plist") else {
            fatalError("Environment: Info.plist was not found. Make sure it is included it in the specified bundle.")
        }
        
        guard let data = FileManager.default.contents(atPath: path) else {
            fatalError("Environment: Could not read environment file.")
        }
        
        do {
            var format = PropertyListSerialization.PropertyListFormat.xml
            let infoDict = try PropertyListSerialization.propertyList(
                from: data,
                options: .mutableContainersAndLeaves,
                format: &format
            ) as! [String: Any]
            self.data = infoDict["Environment"] as! [String: Any]
        } catch {
            fatalError("Environment: Could not deserialize environment file.")
        }
    }
    
    var baseUrl: URL {
        URL(string: value(for: "BaseUrl"))!
    }
    
    private func value<T>(for key: String, fallback: (() -> T)? = nil) -> T {
        if let value = data[key] as? T {
            return value
        }
        if let fallback = fallback {
            return fallback()
        }
        fatalError("Environment: No value or fallback given for key \(key).")
    }
    
    private func value<T>(for key: String, fallback: T? = nil) -> T {
        guard let fallback = fallback else {
            return value(for: key, fallback: nil)
        }
        return value(for: key, fallback: { fallback })
    }
    
}
