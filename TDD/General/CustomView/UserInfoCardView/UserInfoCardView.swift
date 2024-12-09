//
//  UserInfoCardView.swift
//  TDD
//
//  Created by 최안용 on 8/10/24.
//

import SwiftUI

struct UserInfoCardView: View {
    @State var user: UserInfo
    
    var isPresentCloseBtn: Bool
    var openGit: () -> Void
    var action: () -> Void
    var deleteAction: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {  
            if isPresentCloseBtn {
                HStack {
                    Spacer()
                    Button(action: {
                        deleteAction()
                    }, label: {
                        Image(.cardClose)
                    })
                    .buttonStyle(.borderless)
                }
                .padding(.horizontal, 8)
                .padding(.top, 8)
            } else {
                HStack { Spacer() }
                    .padding(.horizontal, 8)
                    .padding(.top, 24)
            }
                       
            URLImageView(urlString: user.profileUrl)
                .frame(width: 86, height: 86)
                .background(Color.shadow)
                .clipShape(Circle())
                .padding(.bottom, 8)
            
            Text("\(user.userName)")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Color.fixBk)
                .padding(.bottom, 4)
            
            Button(action: {
                openGit()
            }, label: {
                Text("\(user.gitUrl)")
                    .font(.system(size: 8, weight: .thin))
            })
            .buttonStyle(.borderless)
            .tint(Color.fixBk)
            .padding(.bottom, 12)
            .contentShape(Rectangle())
            
            Button(action: {
                action()
                switch user.status {
                case .FOLLOWING, .REQUEST:
                    break
                case .NOT_FRIEND:
                    user.status = .REQUEST
                case .RECEIVE:
                    user.status = .FOLLOWING
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
            .buttonStyle(.borderless)
            .disabled(user.status == .REQUEST || user.status == .FOLLOWING)
            .padding(.bottom, 21)
            .contentShape(Rectangle())
        }
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .shadow(radius: 1)
        }
        .contentShape(Rectangle())
        .frame(width: 168, height: 213)
    }
}

#Preview {
    UserInfoCardView(user: .stu4, isPresentCloseBtn: true) {
        
    } action: {} deleteAction: {}
}
