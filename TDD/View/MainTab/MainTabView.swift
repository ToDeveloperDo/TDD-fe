//
//  MainTabView.swift
//  TDD
//
//  Created by 최안용 on 7/11/24.
//

import SwiftUI
import UIKit

struct MainTabView: View {
    @State private var selectedTab: MainTabType = .calendar
    @StateObject var viewModel: MainTabViewModel
    @EnvironmentObject private var container: DIContainer
    
    var body: some View {
        contentView
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
}

extension MainTabView {
    var loadedView: some View {
        NavigationStack(path: $container.navigationRouter.destinations) {
            ZStack(alignment: .bottom) {
                tabView.zIndex(0)
                bottomTabs.zIndex(1)
            }
            .ignoresSafeArea()
            .navigationDestination(for: NavigationDestination.self) {
                NavigationRoutingView(destination: $0)
            }
        }
    }
    
    var tabView: some View {
        TabView(selection: $selectedTab) {
            ForEach(MainTabType.allCases, id: \.self) { tab in
                Group {
                    switch tab {
                    case .calendar:
                        CalendarView(viewModel: .init(container: container))
                            .setTabBarVisibility(isHidden: true)
                    case .quest:
                        QuestView(viewModel: .init(container: container))
                    case .myInfo:
                        MyProfileView(viewModel: .init(container: container))
                    }
                }

            }
        }
    }
    
    var bottomTabs: some View {
        HStack(alignment: .top) {
            Spacer()
            HStack(alignment: .top, spacing: 92) {
                ForEach(MainTabType.allCases, id: \.self) { tab in
                    VStack(spacing: 8) {
                        Image(tab.imageName(selected: selectedTab == tab))
                        
                        Text("\(tab.title)")
                            .font(.system(size: 11, weight: .regular))
                            .foregroundStyle(Color(tab.colorName(selected: selectedTab == tab)))
                    }
                    .frame(width: 32, height: 50)
                    .onTapGesture {
                        selectedTab = tab
                    }
                }
            }
            .padding(.bottom, 20)
            Spacer()
        }
        .frame(height: 80)
        .background {
            Color.fixWh
                .cornerRadius(20, corners: [.topLeft, .topRight])
                .shadow(radius: 1)
                
        }
        
    }
}

struct MainTabView_Previews: PreviewProvider {
    static let container: DIContainer = .init(services: StubService())
    static let navigationRouter: NavigationRouter = .init()
    
    static var previews: some View {
        MainTabView(viewModel: .init(container: container))
            .environmentObject(container)
    }
}
