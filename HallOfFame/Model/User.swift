//
//  User.swift
//  HallOfFame
//
//  Created by Andreas Pfurtscheller on 03.11.21.
//

import Foundation

struct ImageResource: Decodable {
    let path: String
    let width: Int
    let height: Int
}

struct User: Decodable {
    let username: String
    let key: String
    let avatar: ImageResource
    let displayName: String
    
    enum CodingKeys: String, CodingKey {
        case username, key = "userKey", avatar = "profilePicture", displayName
    }
}
