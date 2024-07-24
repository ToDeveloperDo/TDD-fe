//
//  TodoDetailView.swift
//  TDD
//
//  Created by 최안용 on 7/24/24.
//

import SwiftUI

struct TodoDetailView: View {
    private var todo: Todo
    
    init(todo: Todo) {
        self.todo = todo
    }
    
    var body: some View {
        Text("\(todo)")
    }
}

#Preview {
    TodoDetailView(todo: .init(todoListId: 1, content: "dksj", memo: "dksjf", tag: "dkfj", status: .DONE))
}
