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
    @State private var isRefreshing = false
    private let columns = Array(repeating: GridItem(.fixed(170)), count: 2)
    
    var body: some View {
        NavigationStack(path: $container.navigationRouter.destinations) {
            RefreshableScrollView(isRefreshing: $isRefreshing) {
                self.refresh()
            } content: {
                VStack(spacing: 0) {
                    MyProfileCell(viewModel: viewModel)
                        .padding(.top, 116)
                        .background(Color.fixWh)
                    
                    BtnView(viewModel: viewModel)
                    
                    SearchBar(text: $viewModel.searchName) {
                        
                    }
                    .padding(.bottom, 14)
                    .padding(.horizontal, 24)
                    
                    
                    if viewModel.users.isEmpty {
                        EmptyView(viewModel: viewModel)
                            .padding(.top, 82)
                    } else {
                        LazyVGrid(columns: columns, spacing: 8) {
                            ForEach(viewModel.users) { user in
                                UserInfoCardView(user: user) {
                                    viewModel.accept(id: user.userId) // State 값 주기
                                }
                                .onTapGesture {
                                    viewModel.send(action: .clickedUserCell(user: user))
                                }
                            }
                        }
                    }
                }
                .background(Color.mainbg)
            }
            .ignoresSafeArea()
            .background(Color.white.edgesIgnoringSafeArea(.bottom))
            .toolbar {
                ToolbarItem {
                    Button(action: {
                        // TODO: -
                    }, label: {
                        Image(.settingIcon)
                    })
                }
            }
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(Color.fixWh, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .navigationDestination(for: NavigationDestination.self) {
                NavigationRoutingView(destination: $0)
            }
        }
    }
    
    private func refresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isRefreshing = false
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
            Text("\(viewModel.myInfo?.name ?? "이름")")
                .font(.system(size: 28, weight: .semibold))
                .foregroundStyle(Color.text)
                .padding(.bottom, 8)
                .padding(.horizontal, 24)
            Button(action: {
                
            }, label: {
                Text("\(viewModel.myInfo?.gitUrl ?? "url")")
                    .font(.system(size: 14, weight: .light))
                    .tint(Color.text)
            })
            .padding(.horizontal, 24)
        }
        .padding(.bottom, 17)
        .background(Color.mainbg)
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
                    .frame(width: 40, height: 45)
            Text(viewModel.selectedMode.emptyTitle)
                    .font(.system(size: 14, weight: .light))
                    .foregroundStyle(Color.serve)
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
