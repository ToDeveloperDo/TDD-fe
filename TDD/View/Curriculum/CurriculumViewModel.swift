//
//  CurriculumViewModel.swift
//  TDD
//
//  Created by 최안용 on 11/10/24.
//

import Foundation
import Combine

final class CurriculumViewModel: ObservableObject {
    @Published var selectedPosition: Position = .web
    @Published var selectedStack: String = ""
    @Published var selectedPeriod: String = ""
    @Published var selectedLevel: String = ""
    @Published var selectedWeek: Int = 0
    @Published var phase: LoadState = .notRequest
    @Published var isLoading: Bool = false
    @Published var isError: Bool = false
    
    enum LoadState {
        case notRequest
        case success
    }
    
    @Published var curriculums: [Curriculum] = [.init(object: "1주차", contents: [.init(title: "가"),.init(title: "나"),.init(title: "다")]),
                                     .init(object: "2주차", contents: [.init(title: "가"),.init(title: "나"),.init(title: "다")])]
    
    private var container: DIContainer
    private var subscriptions = Set<AnyCancellable>()
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func updateSelection(for section: SectionInfo, with value: String) {
        switch section {
        case .position:
            if let newPosition = Position(rawValue: value) {
                selectedPosition = newPosition
                selectedStack = ""
                selectedPeriod = ""
                selectedLevel = ""
            }
        case .stack:
            selectedStack = value
        case .period:
            selectedPeriod = value
        case .level:
            selectedLevel = value
        }
    }
    
    func buttonValiadation() -> Bool {
        selectedStack.isEmpty || selectedPeriod.isEmpty || selectedLevel.isEmpty
    }
    
    func addButtonValidation() -> Bool {
        return !curriculums[self.selectedWeek].contents.contains { $0.isSelected } || curriculums[self.selectedWeek].isRegistration
    }
    
    func tappedButton() {
        isLoading = true
        container.services.curriculumService.fetchCurriculum(
            position: selectedPosition.rawValue,
            stack: selectedStack,
            experience: selectedLevel,
            period: selectedPeriod
        )
        .sink { [weak self] completion in
            if case .failure(_) = completion {
                self?.phase = .notRequest
                self?.isLoading = false
                self?.isError = true
            }
        } receiveValue: { [weak self] curriculums in
            self?.curriculums = curriculums
            self?.isLoading = false
            self?.phase = .success
        }
        .store(in: &subscriptions)

    }
    
    func tappedSubject(subject: DetailSubject) {
        if let index = curriculums[self.selectedWeek].contents.firstIndex(where: {$0.id == subject.id}) {
            curriculums[selectedWeek].contents[index].isSelected.toggle()
        }
    }
    
    func addButtonTapped() {
        isLoading = true
        let calendar = Calendar.current
        let currentDate = Date()
        let selectedSubjects = curriculums[self.selectedWeek].contents.filter({ $0.isSelected })
        
        let networkRequests = selectedSubjects.enumerated().map { index, subject -> AnyPublisher<Int64, ServiceError> in
            let weekadjustedDate = calendar.date(byAdding: .weekOfYear, value: selectedWeek, to: currentDate) ?? currentDate
            let adjustedDate = calendar.date(byAdding: .day, value: index * 2, to: weekadjustedDate)
            let stringDate = adjustedDate?.format("yyyy-MM-dd") ?? ""
            
            let todo = Todo(content: subject.title,
                            memo: "",
                            tag: "커리큘럼",
                            deadline: stringDate,
                            status: .PROCEED)
            
            return container.services.todoService.createTodo(todo: todo)
        }
        
        // 네트워크 요청을 하나의 Combine 스트림으로 결합
        Publishers.MergeMany(networkRequests)
            .collect() // 모든 요청이 완료될 때까지 기다림
            .sink { [weak self] completion in
                switch completion {
                case .failure:
                    break
//                    self?.isError = true
                case .finished:
                    break
                }
                self?.isLoading = false // 모든 요청 완료 후 업데이트
                self?.curriculums[self?.selectedWeek ?? 0].isRegistration = true
            } receiveValue: { _ in
            }
            .store(in: &subscriptions)
    }
}
