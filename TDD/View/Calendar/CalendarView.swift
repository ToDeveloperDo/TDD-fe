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
    @State private var textFieldOffset: CGFloat = 0
    
    private let columns = Array(repeating: GridItem(.flexible()), count: 7)
    private let calendarHeight: CGFloat = UIScreen.main.bounds.height/3
    
    var body: some View {
        ZStack {
            VStack {
                calendarHeader
                ScrollView {
                    VStack {
                        calendarBody
                        todoListView
                    }
                }
            }
            .overlay {
                if viewModel.showTextField {
                    Color.gray.opacity(0.5)
                        .ignoresSafeArea()
                }
            }
            .onTapGesture {
                viewModel.showTextField = false
                focusField = nil
            }
            plusBtnView
            
            if viewModel.showTextField {
                todoInputView
                .offset(y: -keyboardHeight+10)
                .animation(.spring(), value: keyboardHeight)
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
                viewModel.createTodo()
            case nil:
                viewModel.showTextField = false
            }
        }
        .ignoresSafeArea(.keyboard)
        .onPreferenceChange(TextFieldOffsetKey.self, perform: { value in
            self.textFieldOffset = value
            
        })
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
                        Text("\(viewModel.months[viewModel.selection].selectedDay.date.format("yyyy년 MM월 dd일 EEEE"))")
                    } icon: {
                        Image(.icCalendar)
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 20, height: 20)
                            .foregroundStyle(Color.red)
                    }
                                        
                    Spacer()
                    
                    Button(action: {
                        viewModel.createTodo()
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
            .background(Color.fixWh)
            .cornerRadius(10)
            .background(
                GeometryReader { geometry in
                    Color.clear
                        .preference(key: TextFieldOffsetKey.self, value: geometry.frame(in: .global).origin.y)
                }
            )
        }
    }
    
    private var calendarHeader: some View {
        VStack(alignment: .center) {
            if let date = viewModel.months[viewModel.selection].days.first?.date {
                Text(date.format("YYYY년 MMMM"))
                    .font(.title.bold())
            }
            
            LazyVGrid(columns: columns) {
                ForEach(viewModel.dayOfWeek, id: \.self) { day in
                    Text("\(day)")
                }
            }
        }
    }
    
    private var calendarBody: some View {
        TabView(selection: $viewModel.selection) {
            ForEach(viewModel.months.indices, id: \.self) { index in
                let month = viewModel.months[index].days
                DateGrid(month)
                    .tag(index)
                    .onDisappear {
                        viewModel.paginateMonth()
                    }
                    .onAppear {
                        viewModel.paginateMonth()
                    }
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(height: calendarHeight)
        
    }
    
    private var todoListView: some View {
        VStack {
            if viewModel.months[viewModel.selection].selectedDay.todos.isEmpty {
                Text("\(viewModel.months[viewModel.selection].selectedDay.date)\nTodo 없음")
            } else {
                Text("\(viewModel.months[viewModel.selection].selectedDay.todos.first?.memo ?? "")\nTodo 있음")
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
                        viewModel.months[viewModel.selection].selectedDay = value
                    }
            }
        }
    }   
    
    @ViewBuilder
    private func DateCell(value: Day) -> some View {
        VStack(spacing: 0) {
            if value.days != -1 {
                VStack(spacing: 0) {
                    Text("\(value.days)")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(value.date.isToday ? .blue : .gray.opacity(0.8))
                        .frame(width: 36)
                    HStack {
                        ForEach(0..<3) { i in
                            Circle().frame(width: 4).foregroundStyle(.red)
                        }
                    }
                }
                .padding(10)
                .overlay {
                    if value.date == viewModel.months[viewModel.selection].selectedDay.date {
                        Circle()
                            .foregroundStyle(.blue.opacity(0.2))
                    } else if value.date == Date.now.startOfDay {
                        Circle()
                            .foregroundStyle(.red.opacity(0.2))
                    }
                }
            }
        }
        .frame(height: calendarHeight/value.date.numberOfWeeks)
    }
}

#Preview {
    CalendarView(viewModel: .init())
}

