//
//  CalendarView.swift
//  TDD
//
//  Created by 최안용 on 7/11/24.
//

import SwiftUI

struct CalendarView: View {
    enum Field: Hashable {
        case title, meme
    }
    
    @StateObject var viewModel: CalendarViewModel
    @FocusState private var focusField: Field?    
    @State private var keyboardHeight: CGFloat = 0
    
    private let columns = Array(repeating: GridItem(.flexible()), count: 7)
    private let calendarHeight: CGFloat = UIScreen.main.bounds.height/4
    
    var body: some View {
        ZStack {
            VStack {
                calendarHeader
                calendarBody
                todoListView
            }
            .overlay {
                if viewModel.showTextField {
                    Color.gray.opacity(0.5)
                        .ignoresSafeArea()
                        .onTapGesture {
                            viewModel.showTextField = false
                            focusField = nil
                        }
                }
            }            
            plusBtnView
            
            if viewModel.showTextField {
                todoInputView
                    .animation(.linear, value: keyboardHeight)
                    .ignoresSafeArea()
            }
        }
        .background(Color.mainbg)
        .onSubmit {
            switch focusField {
            case .title:
                focusField = .meme
            case .meme:
                viewModel.showTextField = false
                viewModel.send(action: .createTodo)
            case nil:
                viewModel.showTextField = false
            }
        }
        .ignoresSafeArea(.keyboard)
        .onAppear {
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { (notification) in
                if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                    keyboardHeight = keyboardFrame.height
                }
            }
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { (_) in
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
                    .onDisappear {
                        viewModel.send(action: .paginate)
                    }
                    .onAppear {
                        viewModel.send(action: .paginate)
                    }
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(height: calendarHeight)
        
    }
    
    private var plusBtnView: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    viewModel.showTextField = true
                    focusField = .title
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
    
    @ViewBuilder
    private func DateGrid(_ month: [Day]) -> some View {
        LazyVGrid(columns: columns, spacing: 0) {
            ForEach(month) { value in
                DateCell(value: value)
                    .onTapGesture {
                        viewModel.send(action: .selectDay(day: value))
                    }
            }
        }
    }   
    
    @ViewBuilder
    private func DateCell(value: Day) -> some View {
        VStack(spacing: 0) {
            if value.days != -1 {
                ZStack() {
                    Text("\(value.days)")
                        .font(.subheadline)
                        .foregroundStyle(value.date.isToday ? .blue : .text)
                        
                    HStack(spacing: 2) {
                        if !value.todos.isEmpty {
                            if value.todos.count > 3 {
                                Text("+\(value.todos.count)")
                                    .font(.system(size: 8))
                            } else {
                                ForEach(0..<value.todos.count) { _ in
                                    Circle()
                                        .frame(height: 3)
                                }
                            }
                        }
                    }.offset(y: 15)
                }
                .padding(15)
                .frame(height: calendarHeight/value.date.numberOfWeeks)
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
        }
    }
    
    private var todoInputView: some View {
        VStack {
            Spacer()
            VStack {
                TextField("제목", text: $viewModel.title)
                    .focused($focusField, equals: .title)
                    .submitLabel(.next)
                
                TextField("내용", text: $viewModel.memo)
                    .focused($focusField, equals: .meme)
                    .submitLabel(.done)
                HStack {
                    Label {
                        Text("\(viewModel.selectedDay!.date.format("yyyy년 MM월 dd일 EEEE"))")
                    } icon: {
                        Image(.icCalendar)
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 20, height: 20)
                            .foregroundStyle(Color.red)
                    }
                                        
                    Spacer()
                    
                    Button(action: {
                        viewModel.send(action: .createTodo)
                    }, label: {
                        Image(.icUparrow)
                            .resizable()
                            .frame(width: 20, height: 20)
                            .padding(5)
                            .background(
                                RoundedRectangle(cornerRadius: 25)
                                    .foregroundStyle(Color.red)
                            )
                    })
                }
            }
            .padding(.all, 20)
            .padding(.bottom, viewModel.showTextField ?  keyboardHeight-10 : 0)
            .background(Color.fixWh)
            .cornerRadius(10)
        }
    }
    
    private var todoListView: some View {
        VStack(alignment: .leading) {
                if let selectedDay = viewModel.selectedDay {
                    if selectedDay.todos.isEmpty {
                        emptyTodoView
                    } else {
                        List {
                            Section {
                                Text("\(selectedDay.date.format("M월 d일"))")
                                    .font(.caption)
                                    .foregroundStyle(.text)
                                ForEach(selectedDay.todos) { todo in
                                    todoCell(todo: todo)
                                }
                                .onDelete(perform: { indexSet in
                                    
                                })
                                .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                    Button(action: {
                                        
                                    }, label: {
                                        Text("Button")
                                    })
                                }
                            }
                            .listRowSeparator(.hidden)
                            
                            Section {
                                Text("완료")
                                    .font(.caption)
                                    .foregroundStyle(.text)
                            }
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.fixWh)
                            .listStyle(.plain)
                        }
                    }
                }
            }
        .scrollContentBackground(.hidden)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .padding(10)
    }
    @State var isSelected: Bool = false
    private func todoCell(todo: Todo) -> some View {
        HStack {
            Image(isSelected ? .icSelectedBox : .icUnSelectedBox)
                .resizable()
                .frame(width: 20, height: 20)
                .onTapGesture {
                    isSelected.toggle()
                }
            
            Text("\(todo.memo)")
                .font(.caption)
                .foregroundStyle(.text)
        }
    }
    
    private var emptyTodoView: some View {
        VStack {
            Spacer()
            Image(.icCalendarBack)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150)
                .padding(.bottom, 20)
            Text("이 날에는 일정이 없어요")
                .font(.callout)
                .foregroundStyle(.text)
            Spacer()
        }
    }
}

#Preview {
    CalendarView(viewModel: .init())
}

