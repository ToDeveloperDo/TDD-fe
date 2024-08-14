//
//  MainTabView.swift
//  TDD
//
//  Created by 최안용 on 7/11/24.
//

import SwiftUI
import UIKit

struct MainTabView: View {
    @State private var selectedTab: MainTabType = .myInfo
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
        CustomTabBarController()
            .ignoresSafeArea(edges: .vertical)
    }
}


struct CustomTabBarController: UIViewControllerRepresentable {
    @EnvironmentObject private var container: DIContainer
    
    func makeUIViewController(context: Context) -> UITabBarController {
        let tabBarController = UITabBarController()
        
        let calendarVC = UIHostingController(rootView: CalendarView(viewModel: CalendarViewModel(container:container)))
        
        calendarVC.tabBarItem = UITabBarItem(title: "캘린더", image: UIImage(named: "calendar"), tag: 0)

        let searchVC = UIHostingController(rootView:  QuestView(viewModel: QuestViewModel(container: container)))
        searchVC.tabBarItem = UITabBarItem(title: "탐색", image: UIImage(named: "quest"), tag: 1)

        let profileVC = UIHostingController(rootView: MyProfileView(viewModel: MyProfileViewModel(container: container)))
        profileVC.tabBarItem = UITabBarItem(title: "내 정보", image: UIImage(named: "myInfo"), tag: 2)

        // 탭 바 컨트롤러에 뷰 컨트롤러 추가
        tabBarController.viewControllers = [calendarVC, searchVC, profileVC]
        
        // 탭 바 커스터마이징
        let tabBar = tabBarController.tabBar
        tabBar.tintColor = UIColor.main
        
        tabBar.layer.cornerRadius = 20
        tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tabBar.layer.masksToBounds = false // true에서 false로 변경하여 그림자가 보이도록 설정
        
        // 배경 이미지 및 배경색 설정
        tabBar.backgroundImage = UIImage()
        tabBar.backgroundColor = UIColor.fixWh
        
        // 그림자 설정
        tabBar.layer.shadowColor = UIColor.shadow.cgColor
        tabBar.layer.shadowOpacity = 0.6
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -1)
        tabBar.layer.shadowRadius = 20
        tabBar.layer.shadowPath = UIBezierPath(roundedRect: tabBar.bounds,
                                               cornerRadius: 20).cgPath
        
        return tabBarController
    }

    func updateUIViewController(_ uiViewController: UITabBarController, context: Context) {
        // 업데이트 로직이 필요할 경우 여기에 작성
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
