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
                        .padding(.horizontal, 36)
                    TodoListView(todoListViewModel: .init(date: viewModel.clickedCurrentMonthDates ?? Date(), container: container))
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
                            TodoInputView(todoInputViewModel:
                                            TodoInputViewModel(todo:
                                                    .init(content: "",
                                                          memo: "",
                                                          tag: "",
                                                          deadline: date.format("YYYY-MM-dd"),
                                                          status: .PROCEED), date: date
                                            )
                            )
                        }
                    }
                    .ignoresSafeArea()
                }
            }
        }
        .background(Color.mainbg)
        .ignoresSafeArea(.keyboard)
        .environmentObject(viewModel)
    }
    
    private var calendarHeader: some View {
        VStack(alignment: .center) {
            if let date = viewModel.clickedCurrentMonthDates {
                HStack(spacing: 72) {
                    Button(action: {
                        viewModel.selection -= 1
                    }, label: {
                        Image(systemName: "chevron.left")
                    })
                    Text(date.format("YYYY년 MM월"))
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(Color.text)
                    Button(action: {
                        viewModel.selection += 1
                    }, label: {
                        Image(systemName: "chevron.right")
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
                        .font(.system(size: 14, weight: .light))
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
            return Color.main
        } else if isToday {
            return Color.main.opacity(0.5)
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
                    ForEach(0..<day.todosCount, id: \.self) {_ in
                        Circle().frame(width: 2, height: 2)
                            .foregroundStyle(todoCountColor)                        
                    }
                    .offset(y: 15)
                }
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
