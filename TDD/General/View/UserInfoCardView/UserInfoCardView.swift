//
//  UserInfoCardView.swift
//  TDD
//
//  Created by 최안용 on 8/10/24.
//

import SwiftUI

struct UserInfoCardView: View {
    @State var user: UserInfo
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                Image(.cardClose)
                    .resizable()
                    .frame(width: 8, height: 8)
            }
            .padding(.trailing, 8)
            .padding(.top, 8)
            .padding(.bottom, 6)
            
            URLImageView(urlString: user.avatarUrl)
                .frame(width: 86, height: 86)
                .background(Color.shadow)
                .clipShape(Circle())
                .padding(.bottom, 8)
            
            Text("\(user.userName)")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Color.text)
                .padding(.bottom, 4)
            
            Button(action: {
                // TODO: - WebView 호출
            }, label: {
                Text("\(user.gitUrl)")
                    .font(.system(size: 8, weight: .light))
            }).tint(Color.text)
                .padding(.bottom, 12)
            
            Button(action: {
                if user.status == .accept {
                    user.status = .following
                    //TODO: - 요청 수락 API
                } else if user.status == .follow {
                    user.status = .request
                    //TODO: - 요청 API
                }
            }, label: {
                Text("\(user.status.title)")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundStyle(Color(user.status.titleColor))
                    .padding(.horizontal, 53)
                    .padding(.vertical, 11)
                    .background {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(user.status.bgColor))
                    }
                
            })
            .disabled(user.status == .following || user.status == .request)
            .padding(.bottom, 21)
        }
        .frame(width: 168, height: 213)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .shadow(radius: 1)
        }
    }
}

#Preview {
    UserInfoCardView(user: .init(userName: "이준석", avatarUrl: "", gitUrl: "https://github.com", status: .accept))
}
