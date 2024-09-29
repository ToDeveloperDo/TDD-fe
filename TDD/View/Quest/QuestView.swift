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
    @FocusState private var isFocused: Bool
    
    var body: some View {
        ZStack {
            NavigationStack(path: $container.navigationRouter.questDestinations) {
                ScrollView {
                    VStack(spacing: 0) {
                        SearchBar(text: $viewModel.searchName) {
                            viewModel.send(action: .searchUser)
                        }
                        .focused($isFocused)
                        .padding(.top, 28)
                        .padding(.horizontal, 24)
                        if viewModel.isLoading {
                            LoadingView()
                                .padding(.top, 200)
                        } else {
                            MemberCardView(viewModel: viewModel)
                        }
                    }
                    .background(Color.mainbg)
                }
                .scrollIndicators(.hidden)
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

            Color.clear
                .contentShape(Rectangle())
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    isFocused = false
                }
        }
        .overlay {
            if viewModel.networkErr {
                NetworkErrorAlert(title: "네트워크 통신 에러")
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
                            withAnimation {
                                viewModel.networkErr = false
                            }
                        }
                    }
            }
        }
    }
}

private struct MemberCardView: View {
    @ObservedObject private var viewModel: QuestViewModel
    private let columns = Array(repeating: GridItem(.fixed(168)), count: 2)
    
    fileprivate init(viewModel: QuestViewModel) {
        self.viewModel = viewModel
    }
    
    fileprivate var body: some View {
        Group {
            switch viewModel.userListMode {
            case .search:
                if viewModel.searchUsers.isEmpty {
                    VStack {
                        SearchEmptyView()
                            .padding(.top, 200)
                    }
                } else {
                    LazyVGrid(columns: columns, spacing: 13) {
                        ForEach(viewModel.searchUsers) { user in
                            UserInfoCardView(user: user, isPresentCloseBtn: false, openGit: {
                                viewModel.clickedGitUrl = user.gitUrl
                                viewModel.isPresentGit = true
                            }, action: {
                                viewModel.send(action: .clickedInfoType(user: user))
                            }, deleteAction: {
                                // TODO: 삭제 액션 추가
                            })
                            .onTapGesture {
                                viewModel.clickedUserCell(user)
                            }
                        }
                    }
                }
            case .normal:
                LazyVGrid(columns: columns, spacing: 13) {
                    ForEach(viewModel.users) { user in
                        UserInfoCardView(user: user, isPresentCloseBtn: false, openGit: {
                            viewModel.clickedGitUrl = user.gitUrl
                            viewModel.isPresentGit = true
                        }, action: {
                            viewModel.send(action: .clickedInfoType(user: user))
                        }, deleteAction: {
                            // TODO: 삭제 액션 추가
                        })
                        .onTapGesture {
                            viewModel.clickedUserCell(user)
                        }
                    }
                }
            }
        }
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
