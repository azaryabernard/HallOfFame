//
//  Stakeholder.swift
//  HallOfFame
//
//  Created by Andreas Pfurtscheller on 03.11.21.
//

import Foundation

struct Stakeholder {
    let key: String
    let name: String
    let imageUrl: URL?
}

struct StakeholderGroup {
    let title: String
    let stakeholders: [Stakeholder]
}
