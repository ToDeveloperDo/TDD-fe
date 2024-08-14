//
//  MyInfoView.swift
//  TDD
//
//  Created by 최안용 on 7/11/24.
//

import SwiftUI

struct MyProfileView: View {
    @StateObject var viewModel: MyProfileViewModel
    private let columns = Array(repeating: GridItem(.fixed(170)), count: 2)
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                MyProfileCell(viewModel: viewModel)
                    .padding(.top, 115)
                
                BtnView(viewModel: viewModel)
                
                SearchBar(text: $viewModel.searchName) {
                    
                }
                .padding(.bottom, 14)
                .padding(.horizontal, 24)
                .background(Color.mainbg)
                
                if viewModel.users.isEmpty {
                    VStack {
                        Spacer()
                        Text("없음")
                        Spacer()
                    }
                } else {
                    LazyVGrid(columns: columns, spacing: 8) {
                        ForEach(viewModel.users) { user in
                            UserInfoCardView(user: user) {
                                viewModel.accept(id: user.userId)
                            } action2: {
                                viewModel.send(id: user.userId)
                            }

                        }
                    }
                    .background(Color.mainbg)
                }
                
                
            }
        }
        .scrollIndicators(.hidden)
        .background(Color.fixWh)
        .background(Color.white.edgesIgnoringSafeArea(.bottom))
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
        .background(Color.mainbg)
    }
}

#Preview {
    MyProfileView(viewModel: .init(users: [.stu1, .stu2, .stu3, .stu4], container: .stub))
}
