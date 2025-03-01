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
            .fullScreenCover(isPresented: $viewModel.isPresentCreateRepo) {
                CreateRepoView(viewModel: .init(mainTabViewModel: viewModel, container: container))
            }
    }
    
    @ViewBuilder
    var contentView: some View {
        switch viewModel.phase {
        case .notRequest:
            PlaceholderView()
               .onAppear {
                    viewModel.send(action: .checkGitLink)
                }
        case .loading:
            LoadingView()
        case .success:
            loadedView
        case .fail:
            ErrorView()
        case .notLink:
            LinkGitHubView(viewModel: .init(container: container, mainTabViewModel: viewModel))
        }
    }
}

extension MainTabView {
    var loadedView: some View {
        ZStack(alignment: .bottom) {
            tabView.zIndex(0)
            bottomTabs.zIndex(1)
        }
        .ignoresSafeArea()
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
                    case .curriculum:
                        CurriculumListView(viewModel: .init(container: container))
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
            HStack(alignment: .top, spacing: 65) {
                ForEach(MainTabType.allCases, id: \.self) { tab in
                    VStack(spacing: 8) {
                        Image(tab.imageName(selected: selectedTab == tab))
                            .resizable()
                            .frame(width: 26, height: 26)
                        
                        Text("\(tab.title)")
                            .font(.system(size: 11, weight: .regular))
                            .foregroundStyle(Color(tab.colorName(selected: selectedTab == tab)))
                    }
                    .onTapGesture {
                        selectedTab = tab
                    }
                }
            }
            .padding(.top, 15)
            .padding(.bottom, 21)
            Spacer()
        }
        .background {
            Color.fixWh
                .cornerRadius(20, corners: [.topLeft, .topRight])
                .shadow(radius: 1)
                
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static let container: DIContainer = .init(services: StubService())
    
    static var previews: some View {
        MainTabView(viewModel: .init(container: container))
            .environmentObject(container)
    }
}
