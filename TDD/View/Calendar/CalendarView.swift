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
    
    private let columns = Array(repeating: GridItem(.flexible()), count: 7)
    private let calendarHeight: CGFloat = UIScreen.main.bounds.height/3
    
    var body: some View {
        GeometryReader {_ in 
            ZStack {
                VStack(spacing: 0) {
                    calendarHeader
                        .padding(.top, 29)
                        .padding(.bottom, 8)
                    calendarBody
                        .padding(.horizontal, 24)
                    
                    if viewModel.isTodoLoading {
                        LoadingView()
                    } else {
                        TodoListView(
                            viewModel: .init(
                                todos: viewModel.currentTodos(),
                                todosCount: viewModel.currentTodosCount()
                            )
                        )
                    }
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
                        if let date = viewModel.clickedCurrentMonthDates {
                            TodoInputView(
                                todoInputViewModel: .init(
                                    todo:  .init(content: "",
                                                 memo: "",
                                                 tag: "",
                                                 deadline: date.format("YYYY-MM-dd"),
                                                 status: .PROCEED), date: date))
                        }
                    }
                    .ignoresSafeArea()
                }
            }
        }
        .overlay {
            if viewModel.isSlidingLoading {
                Color.gray.opacity(0.1).ignoresSafeArea()
            }
            if viewModel.isError {
                NetworkErrorAlert(title: "네트워크 통신 에러")
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
                            withAnimation {
                                viewModel.isError = false
                            }
                        }
                    }
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .background(Color.mainbg)
        .ignoresSafeArea(.keyboard)        
        .sheet(isPresented: $viewModel.isPresent) {
            if let todo = viewModel.detailTodo,
               let date = viewModel.clickedCurrentMonthDates {
                TodoDetailView(todoDetailViewModel: .init(todo: todo, date: date))
                    .presentationDetents([.medium, .large])
            }
        }
        .environmentObject(viewModel)
        .onAppear {
            viewModel.getTodosCount()
            viewModel.onappearFetchTodo()
        }
    }
    
    private var calendarHeader: some View {
        VStack(alignment: .center) {
            if let date = viewModel.clickedCurrentMonthDates {
                HStack(spacing: 72) {
                    Button(action: {
                        viewModel.selection -= 1
                    }, label: {
                        Image(.previousBtn)
                    })
                    Text(date.format("YYYY년 MM월"))
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(Color.fixBk)
                    Button(action: {
                        viewModel.selection += 1
                    }, label: {
                        Image(.nextBtn)
                    })
                }
            }
        }
        .padding(.horizontal, 51)
        
    }
    
    private var calendarBody: some View {
        VStack(spacing: 0) {
            LazyVGrid(columns: columns) {
                ForEach(viewModel.dayOfWeek, id: \.self) { day in
                    Text("\(day)")
                        .font(.system(size: 14, weight: .thin))
                        .foregroundStyle(Color.calendarDayGray)
                }
                
            }
            .padding(.top, 13)
            .padding(.horizontal, 16)
            
            TabView(selection: $viewModel.selection) {
                ForEach(viewModel.months.indices, id: \.self) { index in
                    DateGrid(viewModel.months[index].days)
                        .tag(index)
                }
                .padding(.horizontal, 16)
                
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: calendarHeight)
        }
        .padding(.top, 15)
    }
    
    private func DateGrid(_ month: [Day]) -> some View {
        VStack {
            LazyVGrid(columns: columns, spacing: 5) {
                ForEach(0..<42) { index in
                    let clicked = viewModel.months[viewModel.selection].selectedDay == month[index].date
                    let isToday = month[index].date.isToday
                    Group {
                        if month[index].isCurrentMonthDay {
                            DateCell(day: month[index], clicked: clicked, isToday: isToday)
                        } else {
                            DateCell(day: month[index], isCurrentMonthDay: false)
                        }
                    }
                    .onTapGesture {
                        if month[index].isCurrentMonthDay {
                            viewModel.clickedCurrentMonthDates = month[index].date
                        }
                    }
                }
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
                    Image(.plusBtn)
                        
                })
                .frame(width: 64, height: 64)
            }
        }
        .padding(.horizontal, 14)
        .padding(.bottom, 110)
    }
}

private struct DateCell: View {
    private var day: Day
    private var clicked: Bool
    private var isToday: Bool
    private var isCurrentMonthDay: Bool
    
    private var textColor: Color {
        if clicked || isToday  {
            return Color.fixWh
        } else if isCurrentMonthDay {
            return Color.daycellGray
        } else {
            return Color.daycellGray2
        }
    }
    private var backgroundColor: Color {
        if clicked {
            return Color.primary100
        } else if isToday {
            return Color.primary100.opacity(0.5)
        } else {
            return Color.mainbg
        }
    }
    
    private var todoCountColor: Color {
        if clicked || isToday {
            return Color.fixWh
        } else {
            return Color.fixBk
        }
    }
    
    fileprivate init(
      day: Day,
      clicked: Bool = false,
      isToday: Bool = false,
      isCurrentMonthDay: Bool = true
    ) {
      self.day = day
      self.clicked = clicked
      self.isToday = isToday
      self.isCurrentMonthDay = isCurrentMonthDay
    }
    
    fileprivate var body: some View {
        VStack {
            Circle()
                .fill(backgroundColor)
                .overlay(
                    Text("\(day.days)")
                        .font(.system(size: 16, weight: .light))
                )
                .foregroundStyle(textColor)
        }
        .frame(width: 40, height: 40)
        .overlay {
            if day.isCurrentMonthDay && day.todosCount != 0 {
                HStack(spacing: 2) {
                    if day.todosCount < 4 {
                        ForEach(0..<day.todosCount, id: \.self) {_ in
                            Circle().frame(width: 2, height: 2)
                                .foregroundStyle(todoCountColor)
                        }
                    } else {
                        Text("+\(day.todosCount)")
                            .font(.system(size: 8, weight: .thin))
                            .foregroundStyle(todoCountColor)
                    }
                }
                .offset(y: 15)
            }
        }
    }
}

struct CalendarView_Previews: PreviewProvider {
    static let container: DIContainer = .init(services: StubService())
    
    static var previews: some View {
        CalendarView(viewModel: CalendarViewModel(container: Self.container))
            .environmentObject(Self.container)
    }
}
