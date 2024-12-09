//
//  Curriculum.swift
//  TDD
//
//  Created by 최안용 on 11/13/24.
//

import Foundation

struct Curriculum {
    var isRegistration = false
    let object: String
    var contents: [DetailSubject]
}

struct DetailSubject: Identifiable {
    var isSelected: Bool = false
    let id =  UUID()
    let title: String
}
