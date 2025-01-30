//
//  CurriculumListViewModel.swift
//  TDD
//
//  Created by 최안용 on 12/15/24.
//

import Foundation
import Combine

final class CurriculumListViewModel: ObservableObject {
    @Published var curriculumList: [Plan] = []
    
    var container: DIContainer
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(container: DIContainer) {
        self.container = container
    }
    
    enum Action {
        case tappedCurriculumCell(plan: Plan)
        case tappedCreateButton
        case fetchCurriculumList
    }
    
    func send(action: Action) {
        switch action {
        case .tappedCurriculumCell(let plan):
            tappedCurriculumCell(plan: plan)
        case .tappedCreateButton:
            tappedCreateButton()
        case .fetchCurriculumList:
            fetchCurriculumList()
        }
    }
}

extension CurriculumListViewModel {
    private func tappedCreateButton() {
        container.navigationRouter.push(to: .createCurriculum, on: .curriculum)
    }
    
    private func tappedCurriculumCell(plan: Plan) {
        container.navigationRouter.push(to: .fetchedCurriculum(curriculums: nil, id: plan.planId, selectedStep: [:]), on: .curriculum)
    }
    
    private func fetchCurriculumList() {
        container.services.curriculumService.fetchPlan()
            .sink { completion in
                print(completion)
            } receiveValue: { [weak self] result in
                self?.curriculumList = result
            }
            .store(in: &subscriptions)
    }
}
