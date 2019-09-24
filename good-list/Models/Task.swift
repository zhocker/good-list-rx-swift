//
//  Task.swift
//  good-list
//
//  Created by macbook on 9/24/19.
//  Copyright © 2019 Tanawat Polsuwan. All rights reserved.
//

import Foundation

enum Priority : Int {
    case high
    case medium
    case low
}

struct Task {
    let title : String
    let priority : Priority
}
