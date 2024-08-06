//
//  MainTabView.swift
//  TDD
//
//  Created by 최안용 on 7/11/24.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: MainTabType = .calendar
    @StateObject var viewModel: MainTabViewModel
    @EnvironmentObject private var container: DIContainer
    
    var body: some View {
        NavigationStack(path: $container.navigationRouter.destinations) {
            contentView
                .navigationDestination(for: NavigationDestination.self) {
                    NavigationRoutingView(destination: $0)
                }
        }
    }
    
    @ViewBuilder
    var contentView: some View {
        switch viewModel.phase {
        case .notRequest:
            PlaceholderView()
                .onAppear {
                    viewModel.send(action: .checkRepoCreate)
                }
        case .loading:
            LoadingView()
        case .success:
            loadedView
        case .fail:
            ErrorView()
        case .notCreateRepo:
            CreateRepoView(viewModel: CreateRepoViewModel(mainTabViewModel: viewModel, container: container))
                .fullScreenCover(isPresented: $viewModel.isPresentGitLink) {
                    LinkGitHubView(viewModel: .init(container: container, mainTabViewModel: viewModel))
                }
                .onAppear {
                    viewModel.send(action: .checkGitLink)
                }            
        }
    }
    
    var loadedView: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                ForEach(MainTabType.allCases, id: \.self) { tab in
                    Group {
                        switch tab {
                        case .calendar:
                            CalendarView(viewModel: CalendarViewModel(container: container))
                        case .myInfo:
                            MyInfoView()
                        case .todo:
                            ContentView()
                        }
                    }
                    .tabItem {
                        Label(tab.title, systemImage: tab.systemImageName)
                    }
                    .tag(tab)
                }
            }
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static let container: DIContainer = .init(services: StubService())
    static let navigationRouter: NavigationRouter = .init()
    
    static var previews: some View {
        MainTabView(viewModel: .init(container: Self.container))
            .environmentObject(Self.container)
    }
}
