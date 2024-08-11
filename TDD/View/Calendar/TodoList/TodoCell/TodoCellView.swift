//
//  TodoCellView.swift
//  TDD
//
//  Created by 최안용 on 7/30/24.
//

import SwiftUI

struct TodoCellView: View {
     var isSelected: Bool
    @EnvironmentObject private var viewModel: CalendarViewModel
    
    private var todo: Todo
    var onCheckboxTapped: () -> Void = {}
    
    init(isSelected: Bool = false, todo: Todo, _ onCheckboxTapped: @escaping () -> Void) {
        self.isSelected = isSelected
        self.todo = todo
        self.onCheckboxTapped = onCheckboxTapped
    }
    
    var body: some View {
        HStack(spacing: 8) {
            Button(action: {
                onCheckboxTapped()
            }, label: {
                Image(isSelected ? .icSelectedBox : .icUnSelectedBox)
                    .resizable()
                    .frame(width: 18, height: 18)
            })
            
            Text("\(todo.content)")
                .font(.system(size: 12, weight: .light))
                .foregroundStyle(.text)
            Spacer()
            Button(action: {
                
            }, label: {
                Text("더보기")
                    .font(.system(size: 12, weight: .light))
                    .foregroundStyle(.textGray)
                    .underline()
            })
        }
        .buttonStyle(.borderless)
    }
}



#Preview {
    TodoCellView(todo: .stub1, {})
        .environmentObject(CalendarViewModel(container: .stub))
}
