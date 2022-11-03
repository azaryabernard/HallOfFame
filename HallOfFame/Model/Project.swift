//
//  Project.swift
//  HallOfFame
//
//  Created by Andreas Pfurtscheller on 03.11.21.
//

import Foundation
import UIKit

struct Project {
    let key: String
    let identifier: String
    let title: String
    let image: UIImage?
    let customer: Customer
    let customers: [User]
    let projectLeads: [User]
    let coaches: [User]
    let developers: [User]
}
