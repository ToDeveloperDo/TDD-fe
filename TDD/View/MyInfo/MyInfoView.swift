//
//  MyInfoView.swift
//  TDD
//
//  Created by 최안용 on 7/11/24.
//

import SwiftUI

struct MyInfoView: View {
    private let columns = Array(repeating: GridItem(.fixed(170)), count: 2)
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                MyProfileCell()
                    .padding(.top, 115)
                BtnView()
                SearchBar(text: "")
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(0..<100) {_ in
                        UserInfoCardView(user: .init(userName: "이준석", avatarUrl: "", gitUrl: "https://github.com", status: .follow))
                    }
                }
                .background(Color.mainbg)
                
            }
        }
        .scrollIndicators(.hidden)
        .background(Color.fixWh)
        .background(Color.white.edgesIgnoringSafeArea(.bottom))
    }
}

private struct MyProfileCell: View {
    fileprivate var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            UserInfoView()
                .padding(.bottom, 28)
            Text("이름")
                .font(.system(size: 28, weight: .semibold))
                .foregroundStyle(Color.text)
                .padding(.bottom, 8)
                .padding(.horizontal, 24)
            Button(action: {
                
            }, label: {
                Text("https://github.com")
                    .font(.system(size: 14, weight: .light))
                    .tint(Color.text)
            })
            .padding(.horizontal, 24)
        }
        .padding(.bottom, 20)
        .background(Color.mainbg)
    }
}

private struct SearchBar: View {
    @State var text: String
    var body: some View {
        HStack(spacing: 12) {
            Image(.search)
            TextField("계정 검색하기", text: $text)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background {
            RoundedRectangle(cornerRadius: 14)
                .foregroundStyle(Color.fixWh)
                .shadow(radius: 1)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 14)
        .background(Color.mainbg)
    }
}

private struct BtnView: View {
    fileprivate var body: some View {
        HStack {
            HStack(spacing: 16) {
                MyInfoBtn(type: .friend, selected: true) {
                    
                }
                
                MyInfoBtn(type: .request, selected: false) {
                    
                }
                
                MyInfoBtn(type: .receive, selected: false) {
                    
                }
            }
            Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 20)
        .background(Color.mainbg)
    }
}

private struct FriendCellView: View {
    var body: some View {
        HStack(spacing: 90) {
            URLImageView(urlString: "")
                .frame(width: 40, height: 40)
                .background {
                    Color.gray.opacity(0.4)
                        .clipShape(Circle())
                        .shadow(radius: 2)
                }
            Text("이준석")
                .font(.headline)
                .foregroundStyle(.text)
            
            Button(action: {}, label: {
                Text("삭제")
                    .font(.headline)
                    .foregroundStyle(.text)
                    .font(.headline)
                    .foregroundStyle(.text)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 20)
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.text, lineWidth: 1)
                            .foregroundStyle(.clear)
                    }
            })
        }.onTapGesture {
            
        }
    }
}

#Preview {
    MyInfoView()
}
