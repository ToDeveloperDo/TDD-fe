//
//  QuestView.swift
//  TDD
//
//  Created by 최안용 on 7/11/24.
//

import SwiftUI

struct QuestView: View {
    @EnvironmentObject private var container: DIContainer
    @StateObject var viewModel: QuestViewModel
    
    var body: some View {
        NavigationStack(path: $container.navigationRouter.questDestinations) {
            ScrollView {
                VStack(spacing: 0) {
                    SearchBar(text: $viewModel.searchName) {
                        
                    }
                    .padding(.top, 28)
                    .padding(.horizontal, 24)
                    if viewModel.isLoading {
                        LoadingView()
                    } else {
                        MemberCardView(viewModel: viewModel)
                    }
                }
                .background(Color.mainbg)
            }
            .background(Color.mainbg)
            .onAppear {
                viewModel.fetchMembers()
            }
            .navigationDestination(for: NavigationDestination.self) {
                NavigationRoutingView(destination: $0)
            }
            .sheet(isPresented: $viewModel.isPresentGit) {
                MyWebView(urlToLoad: URL(string: viewModel.clickedGitUrl)!)
                    .ignoresSafeArea()
            }
        }
    }
}

private struct MemberCardView: View {
    @ObservedObject private var viewModel: QuestViewModel
    private let columns = Array(repeating: GridItem(.fixed(170)), count: 2)
    
    fileprivate init(viewModel: QuestViewModel) {
        self.viewModel = viewModel
    }
    
    fileprivate var body: some View {
        LazyVGrid(columns: columns, content: {
            ForEach(viewModel.users) { user in
                UserInfoCardView(user: user) {
                    viewModel.clickedGitUrl = user.gitUrl
                    viewModel.isPresentGit = true
                } action: {
                    viewModel.clickedUserCell(user)
                }
                .onTapGesture {
                    viewModel.clickedUserCell(user)
                }
                .contentShape(Rectangle())
            }
        })
        .padding(.vertical, 34)
        .padding(.bottom, 20)
    }
}

struct QuestView_Previews: PreviewProvider {
    static let container: DIContainer = .init(services: StubService())
    static let navigationRouter: NavigationRouter = .init()
    
    static var previews: some View {
        QuestView(viewModel: .init(users: [.stu1, .stu2],container: .stub))
            .environmentObject(Self.container)
        
    }
}
