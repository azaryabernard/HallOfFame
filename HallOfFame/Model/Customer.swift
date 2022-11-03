//
//  Customer.swift
//  HallOfFame
//
//  Created by Andreas Pfurtscheller on 03.11.21.
//

import Foundation

struct Customer: Decodable {
    let key: String
    let name: String
    let longName: String?
}
