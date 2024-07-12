//
//  Month.swift
//  TDD
//
//  Created by 최안용 on 7/12/24.
//

import Foundation

struct Month: Identifiable {
    var id = UUID().uuidString
    var day: Int
    var date: Date
    var todo: [String]?
}
