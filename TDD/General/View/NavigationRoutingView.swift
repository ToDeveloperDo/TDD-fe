//
//  NavigationRoutingView.swift
//  TDD
//
//  Created by 최안용 on 7/18/24.
//

import SwiftUI

struct NavigationRoutingView: View {
    @EnvironmentObject private var container: DIContainer
    @State var destination: NavigationDestination
    
    var body: some View {
        switch destination {
        case .createRepo:
            CreateRepoView(viewModel: CreateRepoViewModel(container: container))
        case .linkGithub:
            LinkGitHubView(viewModel: .init(container: container))
        }
    }
}
