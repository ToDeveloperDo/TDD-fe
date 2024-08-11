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
            LazyVStack {
                MyProfileCell()
                    .padding(.bottom, 20)
                FriendRequestBtnView()
                    .padding(.bottom, 20)
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(0..<100) {_ in
                        UserInfoCardView(user: .init(userName: "이준석", avatarUrl: "", gitUrl: "https://github.com", status: .follow))
                    }
                }
                
            }
        }
        .background(Color.mainbg)
        .background(Color.white.edgesIgnoringSafeArea(.bottom))
    }
}

private struct MyProfileCell: View {
    
    fileprivate var body: some View {
        HStack(spacing: 50) {
            VStack {
                URLImageView(urlString: "")
                    .frame(width: 80, height: 80)
                    .background {
                        Color.gray.opacity(0.4)
                            .clipShape(Circle())
                            .shadow(radius: 2)
                    }
                Text("이준석")
                    .font(.headline)
                    .foregroundStyle(.text)
            }
            
            VStack {
                HStack(spacing: 50) {
                    VStack {
                        Text("할 일")
                        Text("1")
                    }
                    VStack {
                        Text("친구")
                        Text("1")
                    }
                    VStack {
                        Text("총")
                        Text("2")
                    }
                }
                .font(.headline)
                .foregroundStyle(.text)
            }
        }
    }
}

private struct FriendRequestBtnView: View {
    fileprivate var body: some View {
        HStack {
            Button(action: {}, label: {
                Text("보낸 친구 요청")
                    .font(.headline)
                    .foregroundStyle(.text)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 32)
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.text, lineWidth: 2)
                            .foregroundStyle(.clear)
                    }
                    
            })
            Spacer()
            Button(action: {}, label: {
                Text("받은 친구 요청")
                    .font(.headline)
                    .foregroundStyle(.text)
                    .font(.headline)
                    .foregroundStyle(.text)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 32)
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.text, lineWidth: 2)
                            .foregroundStyle(.clear)
                    }
            })
        }.padding(.horizontal, 30)
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
