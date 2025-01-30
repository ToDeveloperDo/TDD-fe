//
//  NavigationRoutingView.swift
//  TDD
//
//  Created by 최안용 on 7/18/24.
//

import SwiftUI

struct NavigationRoutingView: View {
    @EnvironmentObject private var container: DIContainer
    @EnvironmentObject private var authViewModel: AuthenticationViewModel
    @State var destination: NavigationDestination
    
    var body: some View {
        switch destination {
        case let .userDetail(user, parent):
            UserDetailView(viewModel: .init(user: user, parent: parent, container: container))
        case .setting: SettingView(viewModel: .init(container: container, authViewModel: authViewModel))
        case .teamIntroduction: TeamIntroductionView()
        case .personalInformation: PersonalInformationView()
        case .createCurriculum: CurriculumMakeView(viewModel: .init(container: container))
        case let .fetchedCurriculum(curriculums, id, selectedStep): LoadedCurriculumView(
            viewModel: .init(container: container, curriculums: curriculums, id: id, selectedStep: selectedStep)
        )
        }
    }
}
