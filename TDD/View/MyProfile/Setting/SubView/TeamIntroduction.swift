//
//  AboutView.swift
//  TDD
//
//  Created by 최안용 on 8/18/24.
//

import SwiftUI

struct TeamIntroduction: View {
    @EnvironmentObject private var container: DIContainer
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            
            Text("About Us")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(Color.fixBk)
                .padding(.bottom, 24)
            
            AvatarCell(name: "Anyong", 
                       gitHubUrl: "https://github.com/ChoiAnYong",
                       email: "dksdyd78@naver.com",
                       stack: "Swift, SwiftUI",
                       imageString: "anAvatar",
                       role: "FE")
            .padding(.bottom, 48)
            
            AvatarCell(name: "JunStone",
                       gitHubUrl: "https://github.com/JunRock",
                       email: "wnstjr120422@naver.com",
                       stack: "Spring Boot, Spring Data Jpa, Docker, Mysql, Java 17, Kotlin",
                       imageString: "junAvatar",
                       role: "BE")
            .padding(.bottom, 48)
            AvatarCell(name: "Anyong",
                       gitHubUrl: "https://bit.ly/4a0cvCP",
                       email: "naongsiii@gmail.com",
                       stack: "Figma, Ai, Ps",
                       imageString: "naAvatar",
                       role: "PD")
            Spacer()
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    container.navigationRouter.pop()
                } label: {
                    Image(.backBtn)
                }
            }
        }
        .padding(.leading, 24)
        .background(Color.mainbg)
        
    }
}

private struct AvatarCell: View {
    private let name: String
    private let gitHubUrl: String
    private let email: String
    private let stack: String
    private let imageString: String
    private let role: String
    
    fileprivate init(name: String, 
                     gitHubUrl: String,
                     email: String,
                     stack: String,
                     imageString: String,
                     role: String) {
        self.name = name
        self.gitHubUrl = gitHubUrl
        self.email = email
        self.stack = stack
        self.imageString = imageString
        self.role = role
    }
    
    fileprivate var body: some View {
        HStack(spacing: 17) {
            Image(imageString)
            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(name)
                        .font(.system(size: 16, weight: .semibold))
                    Text(role)
                        .font(.system(size: 10, weight: .ultraLight))
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(gitHubUrl)
                    Text(email)
                    Text(stack)
                }.font(.system(size: 10, weight: .ultraLight))
            }
            Spacer()
        }.padding(.leading, 20)
    }
}

#Preview {
    NavigationView {
        TeamIntroduction()
    }
}
