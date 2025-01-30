//
//  LoadedCurriculumViewModel.swift
//  TDD
//
//  Created by 최안용 on 12/22/24.
//

import Foundation
import Combine

final class LoadedCurriculumViewModel: ObservableObject {
    @Published var curriculums: [Curriculum] = []
    @Published var id: Int?
    @Published var selectedWeek: Int = 0
    private var selectedStep: [CurriculumMakeStep : String] = [:]
    
    private var container: DIContainer
    private var subscriptions = Set<AnyCancellable>()
    
    init(container: DIContainer, curriculums: [Curriculum]? = nil, id: Int? = nil, selectedStep: [CurriculumMakeStep : String]) {
        self.container = container
        self.curriculums = curriculums ?? []
        self.id = id
        self.selectedStep = selectedStep
    }
    
    enum Action {
        case tappedCurriculum(curriculum: DetailSubject)
        case tappedWeek(week: Int)
        case tappedRegistration
        case backButtonTapped
        case fetchCurriculum
    }
    
    func send(action: Action) {
        switch action {
        case .tappedCurriculum(let curriculum):
            tappedCurriculum(curriculum: curriculum)
        case .tappedWeek(let week):
            tappedWeek(week: week)
        case .tappedRegistration:
            tappedRegistration()
        case .backButtonTapped:
            backButtonTapped()
        case .fetchCurriculum:
            fetchCurriculum()
        }
    }
}

extension LoadedCurriculumViewModel {
    private func tappedCurriculum(curriculum: DetailSubject) {
        guard let index = curriculums[selectedWeek].contents.firstIndex(where: { $0.id == curriculum.id } ) else { return }
        curriculums[selectedWeek].contents[index].isSelected.toggle()
    }
    
    private func tappedWeek(week: Int) {
        selectedWeek = week
    }
    
    private func tappedRegistration() {
        guard let position = selectedStep[.position],
              let stack = selectedStep[.stack],
              let experience = selectedStep[.level],
              let periodString = selectedStep[.period],
        let period = Int(periodString.split(separator: "개월").first ?? "1") else { return }
        
        var week = 1
        
        var request = RegisterReqeust(
            registerRequest: curriculums.map { $0.toDTO() },
            curriculumRequest: .init(position: position, stack: stack, experienceLevel: experience, targetPeriod: period)
        )
        
        for index in request.registerRequest.indices {
            request.registerRequest[index].weekTitle = "\(week)주차"
            week += 1
        }
        
        container.services.curriculumService.saveCurriculum(request: request)
            .sink { _ in
                
            } receiveValue: { _ in
                
            }
            .store(in: &subscriptions)
        
    }
    
    private func backButtonTapped() {
        container.navigationRouter.pop(on: .curriculum)
    }
    
    private func fetchCurriculum() {
        guard let id = id else { return }
        container.services.curriculumService.fetchCurriculum(id: id)
            .sink { completion in
                print(completion)
            } receiveValue: { [weak self] result in
                self?.curriculums = result
            }
            .store(in: &subscriptions)
    }
}
