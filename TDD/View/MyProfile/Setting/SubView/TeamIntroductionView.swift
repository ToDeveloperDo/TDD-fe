//
//  AboutView.swift
//  TDD
//
//  Created by 최안용 on 8/18/24.
//

import SwiftUI

struct TeamIntroductionView: View {
    @EnvironmentObject private var container: DIContainer
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                Text(attributedString)                    
                    .font(.system(size: 12, weight: .thin))
                
                Text("About Us")
                    .font(.system(size: 18, weight: .semibold))
                    .padding(.bottom, 24)
                    .padding(.top, 48)
                
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
                AvatarCell(name: "NaNa",
                           gitHubUrl: "https://bit.ly/4a0cvCP",
                           email: "naongsiii@gmail.com",
                           stack: "Figma, Ai, Ps",
                           imageString: "naAvatar",
                           role: "PD")
                Spacer()
            }
            
            .padding(.bottom, 100)
            .foregroundStyle(Color.fixBk)
            
        }
        .scrollIndicators(.hidden)
        .padding(.horizontal, 24)
        .background(Color.mainbg)
        .navigationBarBackButtonHidden()
        .toolbarColorScheme(.light, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Text("To developer do, TDD")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(Color.fixBk)
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    container.navigationRouter.pop(on: .myProfile)
                } label: {
                    Image(.backBtn)
                }
            }
        }
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
                        .font(.system(size: 10, weight: .thin))
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(gitHubUrl)
                    Text(email)
                    Text(stack)
                }.font(.system(size: 10, weight: .thin))
            }
            Spacer()
        }.padding(.leading, 20)
    }
}

extension TeamIntroductionView {
    var attributedString: AttributedString {
        var string = AttributedString("""
            TDD 팀의 궁극적인 목표는 "Simple but Useful"입니다. 우리는 개발자에게 필수적인 도구로 자리 잡은 Github와 연동되는 새로운 To do List 플랫폼을 제공합니다. 단순한 To do List 어플리케이션을 넘어, 사용자가 등록한 할 일을 Github에도 자동으로 업로드하여 차별화된 경험을 제공하고자 합니다.
            
            TDD 팀은 "Simple"을 실현하기 위해 To do List 작성 과정을 최대한 간소화했습니다. 복잡한 설정 없이 직관적이고 단순하게 등록할 수 있는 UI를 제공하며, 동시에 "Useful"을 위해 사용자가 작업한 내용은 Github에 기록됩니다. 특히 취업을 준비하는 개발자들이 자신의 이력서에 활용할 수 있도록 돕는 데 중점을 두었습니다.
            
            앞으로도 TDD 팀은 개발자들의 편리함을 최우선으로 생각하며, 더 나은 서비스를 제공하기 위해 지속적으로 노력할 것입니다. 기존의 To Do List와는 차원이 다른, TDD만의 특별한 경험을 만나보세요!
            """)
        if let both = string.range(of: "\"Simple but Useful\"") {
            string[both].font = .system(size: 12, weight: .medium)
        }
        
        if let simple = string.range(of: "\"Simple\"") {
            string[simple].font = .system(size: 12, weight: .medium)
        }
        
        if let useful = string.range(of: "\"Useful\"") {
            string[useful].font = .system(size: 12, weight: .medium)
        }
        return string
    }
}

#Preview {
    NavigationView {
        TeamIntroductionView()
    }
}
