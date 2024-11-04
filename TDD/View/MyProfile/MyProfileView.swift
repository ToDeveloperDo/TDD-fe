//
//  MyInfoView.swift
//  TDD
//
//  Created by 최안용 on 7/11/24.
//

import SwiftUI

struct MyProfileView: View {
    @StateObject var viewModel: MyProfileViewModel
    @EnvironmentObject private var container: DIContainer
    @FocusState private var isFocused: Bool
    
    var body: some View {
        ZStack {
            NavigationStack(path: $container.navigationRouter.myProfileDestinations) {
                VStack(spacing: 0) {
                    ScrollView {
                        VStack(spacing: 0) {
                            MyProfileCell(viewModel: viewModel)
                            
                            BtnView(viewModel: viewModel)
                            
                            SearchBar(text: $viewModel.searchName, action: {
                                viewModel.send(action: .searchUser)
                            })
                            .focused($isFocused)
                            .padding(.vertical, 1)
                            .padding(.bottom, 14)
                            .padding(.horizontal, 24)
                            
                            
                            if viewModel.isLoading {
                                LoadingView()
                                    .padding(.top, 65)
                            } else {
                                MemberCardView(viewModel: viewModel)
                                    .padding(.bottom, 100)
                            }
                        }
                    }
                    .scrollIndicators(.hidden)
                }
                .ignoresSafeArea()
                .background(Color.mainbg)
                .onTapGesture {
                    isFocused = false
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            viewModel.send(action: .clickedSetting)
                        }, label: {
                            Image(.settingIcon)
                        })
                        
                    }
                }
                .toolbarBackground(.hidden, for: .navigationBar)
                .navigationBarBackButtonHidden()
                .navigationDestination(for: NavigationDestination.self) {
                    NavigationRoutingView(destination: $0)
                }
                .sheet(isPresented: $viewModel.isPresentGit) {
                    MyWebView(urlToLoad: URL(string: viewModel.clickedGitUrl)!)
                        .ignoresSafeArea()
                }
            }
        }
        .alert(isPresented: $viewModel.isShowingAlert) {
            switch viewModel.showAlert {
            case .FOLLOWING:
                return Alert(title: Text("친구 목록에서 삭제하시겠습니까?"),
                             primaryButton: .cancel(Text("취소")),
                             secondaryButton: .destructive(Text("확인"), action: {
                    viewModel.send(action: .deleteAction)
                }))
            case .REQUEST:
                return Alert(title: Text("보낸 요청을 삭제하시겠습니까?"),
                             primaryButton: .cancel(Text("취소")),
                             secondaryButton: .destructive(Text("확인"), action: {
                    viewModel.send(action: .deleteAction)
                }))
            case .RECEIVE:
                return Alert(title: Text("받은 요청을 삭제하시겠습니까?"),
                             primaryButton: .cancel(Text("취소")),
                             secondaryButton: .destructive(Text("확인"), action: {
                    viewModel.send(action: .deleteAction)
                }))
            case .NOT_FRIEND:
                return Alert(title: Text("잘못된 요청입니다."), dismissButton: .cancel(Text("확인")))
            }
        }
        .overlay {
            if viewModel.isError {
                NetworkErrorAlert(title: "네트워크 통신 에러")
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
                            withAnimation {
                                viewModel.isError = false
                            }
                        }
                    }
            }
        }
    }
}

private struct MyProfileCell: View {
    @ObservedObject private var viewModel: MyProfileViewModel
    
    init(viewModel: MyProfileViewModel) {
        self.viewModel = viewModel
    }
    
    fileprivate var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            UserInfoView(url: viewModel.myInfo?.profileUrl ?? "")
                .padding(.bottom, 28)
            Text("\(viewModel.myInfo?.name ?? "")")
                .font(.system(size: 28, weight: .semibold))
                .foregroundStyle(Color.fixBk)
                .padding(.bottom, 8)
                .padding(.horizontal, 24)
            Button(action: {
                viewModel.clickedGitUrl = viewModel.myInfo?.gitUrl ?? ""
                viewModel.isPresentGit = true
            }, label: {
                Text("\(viewModel.myInfo?.gitUrl ?? "")")
                    .font(.system(size: 14, weight: .thin))
                    .tint(Color.fixBk)
            })
            .padding(.horizontal, 24)
        }
        .padding(.bottom, 17)
    }
}



private struct BtnView: View {
    @ObservedObject private var viewModel: MyProfileViewModel
    
    init(viewModel: MyProfileViewModel) {
        self.viewModel = viewModel
    }
    
    fileprivate var body: some View {
        HStack {
            HStack(spacing: 16) {
                MyProfileBtn(type: .friend, selected: viewModel.selectedMode == .friend) {
                    viewModel.send(action: .clickedBtn(mode: .friend))
                }
                
                MyProfileBtn(type: .request, selected: viewModel.selectedMode == .request) {
                    viewModel.send(action: .clickedBtn(mode: .request))
                }
                
                MyProfileBtn(type: .receive, selected: viewModel.selectedMode == .receive) {
                    viewModel.send(action: .clickedBtn(mode: .receive))
                }
            }
            Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 12)
    }
}

private struct EmptyView: View {
    @ObservedObject private var viewModel: MyProfileViewModel
    
    
    
    init(viewModel: MyProfileViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: 12) {
            Image(viewModel.selectedMode.imageName)
                    .resizable()
                    .frame(width: viewModel.selectedMode.imageSize.0,
                           height: viewModel.selectedMode.imageSize.1)
            
            Text(viewModel.selectedMode.emptyTitle)
                    .font(.system(size: 14, weight: .light))
                    .foregroundStyle(Color.serve)
        }
        .padding(.top, 65)
    }
}

private struct MemberCardView: View {
    @ObservedObject private var viewModel: MyProfileViewModel
    private let columns = Array(repeating: GridItem(.fixed(168)), count: 2)
    
    fileprivate init(viewModel: MyProfileViewModel) {
        self.viewModel = viewModel
    }
    
    fileprivate var body: some View {
        VStack {
            switch viewModel.userListMode {
            case .search:
                if viewModel.searchUsers.isEmpty {
                    VStack {
                        SearchEmptyView()
                            .padding(.top, 65)
                    }
                } else {
                    LazyVGrid(columns: columns, spacing: 13) {
                        ForEach(viewModel.searchUsers) { user in
                            UserInfoCardView(user: user, isPresentCloseBtn: true) {
                                viewModel.clickedGitUrl = user.gitUrl
                                viewModel.isPresentGit = true
                            } action: {
                                viewModel.send(action: .clickedUserInfoBtn(user: user))
                            } deleteAction: {
                                viewModel.send(action: .clickedCloseBtn(user: user))
                            }
                            .onTapGesture {
                                viewModel.send(action: .clickedUserCell(user: user))
                            }
                        }
                    }
                }
            case .normal:
                if viewModel.users.isEmpty {
                    VStack {
                        EmptyView(viewModel: viewModel)
                    }
                } else {
                    LazyVGrid(columns: columns, spacing: 13) {
                        ForEach(viewModel.users) { user in
                            UserInfoCardView(user: user, isPresentCloseBtn: true) {
                                viewModel.clickedGitUrl = user.gitUrl
                                viewModel.isPresentGit = true
                            } action: {
                                viewModel.send(action: .clickedUserInfoBtn(user: user))
                            } deleteAction: {
                                viewModel.send(action: .clickedCloseBtn(user: user))
                            }
                            .onTapGesture {
                                viewModel.send(action: .clickedUserCell(user: user))
                            }
                        }
                    }
                }
            }
        }
    }
}

struct MyProfileView_Previews: PreviewProvider {
    static let container: DIContainer = .init(services: StubService())
    static let navigationRouter: NavigationRouter = .init()
    
    static var previews: some View {
        MyProfileView(viewModel: .init(container: Self.container))
            .environmentObject(Self.container)
    }
}
