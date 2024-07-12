//
//  CalendarView.swift
//  TDD
//
//  Created by 최안용 on 7/11/24.
//

import SwiftUI

struct CalendarView: View {
    @StateObject var viewModel: CalendarViewModel
    
    private let columns = Array(repeating: GridItem(.flexible()), count: 7)
    private let calendarHeight: CGFloat = UIScreen.main.bounds.height/3
    
    var body: some View {
        VStack {
            calendarHeader
            ScrollView {
                VStack {
                    calendarBody
                    todoListView
                }
                .onAppear { viewModel.fetchMonths() }
            }
        }
    }
    
    private var calendarHeader: some View {
        VStack(alignment: .center) {
            if let date = viewModel.months[1].first?.date {
                Text(date.format("YYYY MMMM"))
                    .font(.footnote)
                    .fontWeight(.semibold)
                Text(date.format("MMMM"))
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
                let month = viewModel.months[index]
                DateGrid(month)
                    .tag(index)
                    .onDisappear {
                        viewModel.paginateMonth()
                    }
                    .onAppear {
                        viewModel.selection = 0
                        viewModel.selection = 1
                    }
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(height: calendarHeight)
    }
    
    private var todoListView: some View {
        VStack {
            if viewModel.selectedDay?.todo == nil {
                Text("없다")
            } else {
                Text("있다.")
            }
        }
    }
    
    @ViewBuilder
    private func DateGrid(_ month: [Month]) -> some View {
        LazyVGrid(columns: columns, spacing: 0) {
            ForEach(month) { value in
                DateCell(value: value)
                    .onTapGesture {
                        viewModel.selectedDay = value
                    }
            }
        }
    }   
    
    @ViewBuilder
    private func DateCell(value: Month) -> some View {
        VStack(spacing: 0) {
            if value.day != -1 {
                VStack {
                    Text("\(value.day)")
                        .fontWeight(value.date.isToday ? .bold : .semibold)
                        .foregroundStyle(value.date.isToday ? .blue : .gray.opacity(0.8))
                        .background(value.date.isToday ? .black : .white)
                }
                .padding(10)
                .overlay {
                        Circle()
                            .foregroundStyle(.blue.opacity(0.2))
                            .opacity(value.date.isSameDay(viewModel.selectedDay?.date ?? Date()) ? 1 : 0)
                }
            }
        }
        .frame(height: calendarHeight/value.date.numberOfWeeks)
    }
    
    
}

#Preview {
    CalendarView(viewModel: .init())
}

