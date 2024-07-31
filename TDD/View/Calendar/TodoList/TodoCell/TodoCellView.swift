//
//  TodoCellView.swift
//  TDD
//
//  Created by 최안용 on 7/30/24.
//

import SwiftUI

struct TodoCellView: View {
    private var isSelected: Bool
    @EnvironmentObject private var viewModel: CalendarViewModel
    
    private var todo: Todo
    var onCheckboxTapped: () -> Void = {}
    
    init(isSelected: Bool = false, todo: Todo, _ onCheckboxTapped: @escaping () -> Void) {
        self.isSelected = isSelected
        self.todo = todo
        self.onCheckboxTapped = onCheckboxTapped
    }
    
    var body: some View {
        Button(action: {
            viewModel.detailTodo = todo
            viewModel.isPresent = true
        }, label: {
            HStack {
                Image(isSelected ? .icSelectedBox : .icUnSelectedBox)
                    .resizable()
                    .frame(width: 20, height: 20)
                    .onTapGesture {
                        onCheckboxTapped()
                    }
                    .padding(5)
                
                Text("\(todo.content)")
                    .font(.caption)
                    .foregroundStyle(.text)
                Spacer()
            }
        })
        .buttonStyle(.borderless)
    }
}



#Preview {
    TodoCellView(todo: .stub1, {})
        .environmentObject(CalendarViewModel(container: .stub))
}
