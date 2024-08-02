//
//  CreateRepoRequest.swift
//  TDD
//
//  Created by 최안용 on 7/22/24.
//

import Foundation

struct CreateRepoRequest: Encodable {
    let repoName: String
    let description: String?
    let isPrivate: Bool
}
