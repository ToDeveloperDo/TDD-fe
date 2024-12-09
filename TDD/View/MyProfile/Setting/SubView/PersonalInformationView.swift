//
//  PersonalInformationView.swift
//  TDD
//
//  Created by 최안용 on 8/25/24.
//

import SwiftUI

struct PersonalInformationView: View {
    @EnvironmentObject private var container: DIContainer
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                Text("\(content)")
                    .font(.system(size: 12, weight: .thin))
                    .padding(.bottom, 100)
            }
            .foregroundStyle(Color.fixBk)
            .navigationBarBackButtonHidden()
            .toolbarColorScheme(.light, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("개인정보 처리 방침")
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
        .scrollIndicators(.hidden)
        .padding(.horizontal, 24)
        .background(Color.mainbg)
    }
}

extension PersonalInformationView {
    var content: String { """

TDD 팀(이하 '앱')은 개인정보 보호법을 준수하며, 사용자의 개인정보를 보호하기 위해 최선을 다하고 있습니다. 본 개인정보 처리방침은 앱이 제공하는 TodoList 서비스(이하 '서비스')와 관련하여 수집, 이용, 보관, 파기 등의 개인정보 처리 방침을 설명합니다.

1. 개인정보의 처리 목적
앱은 다음과 같은 목적으로 개인정보를 처리합니다:

* 서비스 제공 및 회원 관리: 서비스 가입 의사 확인, 회원제 서비스 제공에 따른 본인 식별·인증, 회원 자격 유지·관리 등을 위해 사용자의 개인정보를 처리합니다.
* 이력 관리 및 GitHub 연동: 사용자가 TodoList에 등록한 할 일 목록을 GitHub와 연동하여 이력 관리를 지원합니다.
* 고객지원: 사용자 문의 대응, 문제 해결 및 서비스 관련 공지사항 전달을 위해 개인정보를 처리합니다.

2. 처리하는 개인정보의 항목
앱은 다음과 같은 개인정보를 수집 및 처리합니다:

* 사용자 제공 정보: Apple ID, Apple Email, GitHub 사용자명, GitHub 프로필 사진, GitHub URL
* 자동수집항목: 기기 모델, 고유기기 식별자 등

3. 개인정보의 처리 및 보유 기간
앱은 이용자의 개인정보를 수집 및 이용 목적이 달성될 때까지 보유하며, 관계 법령에 따라 일정 기간 보관할 수 있습니다:

* 서비스 이용 관련 정보: 회원 탈퇴 시까지
* 사용자 정보 관리: 회원 탈퇴 시까지
* 자동수집항목: 회원 탈퇴 시까지

4. 개인정보 처리의 위탁
앱은 원활한 서비스 제공을 위해 다음과 같이 개인정보 처리 업무를 외부에 위탁하고 있습니다:

* 수탁업체: Apple Inc., GitHub Inc.
* 위탁업무 내용: 소셜 로그인 기능 제공 및 GitHub 연동 서비스 제공

5. 개인정보의 국외 이전에 관한 사항
앱은 Apple 및 GitHub와의 연동을 통해 사용자의 개인정보를 미국으로 이전할 수 있습니다. 이 경우, 정보가 이전되는 구체적인 내용은 다음과 같습니다:

* 이전되는 국가: 미국
* 이전되는 개인정보 항목: Apple ID, Apple Email, GitHub 사용자명, GitHub 프로필 사진, GitHub URL
* 이전받는 자: Apple Inc., GitHub Inc.
* 이전 방법: 인터넷을 통한 네트워크 전송

6. 정보주체와 법정대리인의 권리 및 행사방법
이용자와 법정대리인은 다음과 같은 권리를 행사할 수 있으며, 이를 위해 앱에 요청할 수 있습니다:

* 개인정보 열람 요청: 이용자는 앱이 보유하고 있는 자신의 개인정보에 대해 열람을 요청할 수 있습니다. 앱은 열람 요청을 받은 후, 지체 없이 관련 정보를 제공하며, 해당 개인정보가 정확한지 확인할 수 있도록 조치합니다.
* 개인정보 수정 및 정정 요청: 이용자는 자신의 개인정보가 부정확하거나 변경된 경우, 앱에 수정을 요청할 수 있습니다. 앱은 이용자의 요청에 따라 신속하게 해당 정보를 수정하며, 수정이 완료될 때까지 해당 개인정보를 이용하거나 제공하지 않습니다.
* 개인정보 삭제 요청: 이용자는 특정 조건하에 앱이 보유하고 있는 자신의 개인정보 삭제를 요청할 수 있습니다. 예를 들어, 개인정보의 처리 목적이 달성되었거나, 이용자의 동의 철회 등의 사유로 개인정보의 처리가 더 이상 필요하지 않을 경우 삭제 요청이 가능합니다. 앱은 이용자의 요청에 따라 지체 없이 개인정보를 삭제합니다.
* 권리 행사 방법: 상기 권리 행사는 앱에 이메일을 통해 요청할 수 있으며, 앱은 이에 대해 지체 없이 조치를 취하고 그 결과를 통지합니다. 또한, 이용자가 권리 행사를 위해 이메일 요청 시 별도의 수수료는 부과되지 않습니다.

7. 개인정보의 파기 절차 및 방법
앱은 개인정보 보유 기간이 경과하거나 처리 목적이 달성된 경우 지체 없이 해당 개인정보를 파기합니다. 파기는 전자 파일의 경우 복구할 수 없도록 기술적인 방법을 사용하며, 인쇄된 문서의 경우 분쇄 또는 소각하여 처리합니다.

8. 개인정보 보호책임자
앱은 사용자의 개인정보를 보호하고 관련된 불만 처리 및 피해 구제를 위해 아래와 같이 개인정보 보호책임자를 지정하고 있습니다.

* 개인정보 보호책임자
담당자: 최안용
연락처: dksdyd78@naver.com

이용자는 서비스 이용 중 발생하는 모든 개인정보 보호 관련 문의, 불만 처리 등에 관해 개인정보 보호책임자에게 연락할 수 있습니다. 앱은 이용자의 문의에 대해 신속하고 성실하게 답변드릴 것입니다.

9. 기타
앱은 개인정보 처리방침을 개정하는 경우, 앱 공지사항을 통해 사용자에게 고지할 것입니다.

"""
    }
}

#Preview {
    NavigationView {
        PersonalInformationView()
    }
}
