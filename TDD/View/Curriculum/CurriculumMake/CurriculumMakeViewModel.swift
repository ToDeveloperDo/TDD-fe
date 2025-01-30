//
//  CurriculumMakeViewModel.swift
//  TDD
//
//  Created by 최안용 on 12/14/24.
//

import Foundation
import Combine

final class CurriculumMakeViewModel: ObservableObject {
    @Published var step: CurriculumMakeStep = .start
    @Published var selectedKind: [CurriculumMakeStep : String] = [:]
    @Published var isLoading: Bool = false
    
    private var container: DIContainer
    private var subscriptions = Set<AnyCancellable>()
    
    init(container: DIContainer) {
        self.container = container
    }
    
    enum Action {
        case backButtonTapped
        case nextButtonTapped
        case clickedKind(kind: String)        
    }
    
    func send(action: Action) {
        switch action {
        case .backButtonTapped: backButtonTapped()
        case .nextButtonTapped: nextButtonTapped()
        case .clickedKind(let kind): clickedKind(kind: kind)
        }
    }
}

extension CurriculumMakeViewModel {
    func isSelectedKind(kind: String) -> Bool {
        switch step {
        case .start: return false
        case .stack, .position, .period, .level:
            guard let savedKind = selectedKind[step] else { return false }
            return savedKind == kind
        }
    }
    
    func isButtonValid() -> Bool {
        switch step {
        case .start: return true
        case .stack, .position, .period, .level:
            guard let _ = selectedKind[step] else { return false }
            return true
        }
    }
    
    private func backButtonTapped() {
        switch step {
        case .start:
            container.navigationRouter.pop(on: .curriculum)
        case .stack:
            selectedKind[step] = nil
            step = .position
        case .position:
            selectedKind[step] = nil
            step = .start
        case .period:
            selectedKind[step] = nil
            step = .stack
        case .level:
            selectedKind[step] = nil
            step = .period
        }
    }
    
    private func nextButtonTapped() {
        switch step {
        case .start:
            step = .position
        case .stack:
            step = .period
        case .position:
            step = .stack
        case .period:
            step = .level
        case .level:
            guard let position = selectedKind[.position],
                  let stack = selectedKind[.stack],
                  let experience = selectedKind[.level],
                  let period = selectedKind[.period] else { return }
            isLoading = true
            container.services.curriculumService.makeCurriculum(position: position, stack: stack, experience: experience, period: period)
                .sink { completion in
                    
                } receiveValue: { [weak self] result in
                    guard let self = self else { return }
                    self.isLoading = false
                    self.container.navigationRouter.popAndPush(to: .fetchedCurriculum(curriculums: result, id: nil, selectedStep: self.selectedKind), on: .curriculum)
                }
                .store(in: &subscriptions)
        }
    }
    
    private func clickedKind(kind: String) {
        switch step {
        case .start:
            break
        case .stack, .position, .period, .level:
            selectedKind[step] = kind
        }
    }

}
