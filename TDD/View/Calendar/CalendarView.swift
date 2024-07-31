//
//  CalendarView.swift
//  TDD
//
//  Created by 최안용 on 7/11/24.
//

import SwiftUI

struct CalendarView: View {
    @EnvironmentObject var container: DIContainer
    @StateObject var viewModel: CalendarViewModel
   
    @State private var keyboardHeight: CGFloat = 0
    
    private let columns = Array(repeating: GridItem(.flexible()), count: 7)
    private let calendarHeight: CGFloat = UIScreen.main.bounds.height/3
    
    var body: some View {
        ZStack {
            VStack {
                calendarHeader
                calendarBody                    
                TodoListView()
            }
            .overlay {
                if viewModel.showTextField {
                    Color.gray.opacity(0.1)
                        .ignoresSafeArea()
                        .onTapGesture {
                            viewModel.showTextField = false                            
                        }
                }
            }
            plusBtnView
            
            if viewModel.showTextField {
                VStack {
                    Spacer()
                    TodoInputView()
                        .padding(.bottom, viewModel.showTextField ?  keyboardHeight-10 : 0)
                        .animation(.linear, value: keyboardHeight)
                }
                .ignoresSafeArea()
            }
        }
        .environmentObject(viewModel)
        .background(Color.mainbg)

        .ignoresSafeArea(.keyboard)
        .onAppear {
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, 
                                                   object: nil,
                                                   queue: .main) { notification in
                if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                    keyboardHeight = keyboardFrame.height
                }
            }
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification,
                                                   object: nil,
                                                   queue: .main) { _ in
                keyboardHeight = 0
            }
        }
    }
    
    private var calendarHeader: some View {
        VStack(alignment: .center) {
            if let date = viewModel.selectedDay?.date {
                Text(date.format("YYYY년 MMMM"))
                    .font(.title3.bold())
                    .foregroundStyle(Color.text)
            }
            
            LazyVGrid(columns: columns) {
                ForEach(viewModel.dayOfWeek, id: \.self) { day in
                    Text("\(day)")
                        .font(.subheadline)
                        .foregroundStyle(Color.text)
                }
            }
            .padding(.top, 10)
        }
    }
    
    private var calendarBody: some View {
        TabView(selection: $viewModel.selection) {
            ForEach(viewModel.months.indices, id: \.self) { index in
                let month = viewModel.months[index].days
                DateGrid(month)
                    .tag(index)
                    .onAppear {
                        if index == 0 || index == viewModel.months.count - 1 {
                            viewModel.send(action: .paginate)
                        }
                    }
                    .onDisappear {                    
                        viewModel.send(action: .paginate)
                    }
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(height: calendarHeight)
    }
    
    private func DateGrid(_ month: [Day]) -> some View {
        VStack {
            LazyVGrid(columns: columns, spacing: 5) {
                ForEach(0..<42) { index in
                    if index < month.count {
                        DateCell(value: month[index])
                            .onTapGesture {
                                viewModel.send(action: .selectDay(day: month[index]))
                                viewModel.send(action: .fetchTodos)
                            }
                    } else {
                        DateCell(value: .init(days: -1, date: Date()))
                    }
                }
            }
        }
    }
    
    private func DateCell(value: Day) -> some View {
        VStack(spacing: 0) {
            if value.days != -1 {
                ZStack() {
                    Text("\(value.days)")
                        .font(.subheadline)
                        .foregroundStyle(value.date.isToday ? .blue : .text)
                    
                    HStack(spacing: 2) {
                        if value.todosCount != 0 {
                            if value.todosCount > 3 {
                                Text("+\(value.todosCount)")
                                    .font(.system(size: 9))
                            } else {
                                ForEach(0..<value.todosCount, id: \.self) { _ in
                                    Circle()
                                        .frame(height: 3)
                                }
                            }
                        }
                    }.offset(y: 15)
                }
                .padding(15)
            } else {
                Spacer()
            }
        }
        .frame(height: calendarHeight/7)
        .overlay {
            if value.date == viewModel.selectedDay!.date {
                Circle()
                    .foregroundStyle(.blue.opacity(0.2))
            } else if value.date.isToday {
                Circle()
                    .foregroundStyle(.red.opacity(0.2))
            }
        }
    }
    
    private var plusBtnView: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    viewModel.showTextField = true                    
                }, label: {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundStyle(.blue)
                })
            }
        }
        .padding(.horizontal, 10)
    }
}

struct CalendarView_Previews: PreviewProvider {
    static let container: DIContainer = .init(services: StubService())
    
    static var previews: some View {
        CalendarView(viewModel: CalendarViewModel(container: Self.container))
            .environmentObject(Self.container)
    }
}
