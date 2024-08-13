//
//  MyInfoBtn.swift
//  TDD
//
//  Created by 최안용 on 8/13/24.
//

import SwiftUI

struct MyInfoBtn: View {
    private var type: MyInfoBtnType
    private var selected: Bool
    private var action: () -> Void
    
    init(type: MyInfoBtnType, selected: Bool, action: @escaping () -> Void) {
        self.type = type
        self.selected = selected
        self.action = action
    }
    
    var body: some View {
        Button(action: {
            action()
        }, label: {
            Text("\(type.title)")
                .font(.system(size: 12, weight: .light))
                .foregroundStyle(Color(selected ? "fixWh" : "mainColor"))
                .padding(.horizontal, 16)
                .padding(.vertical, 9)
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(selected ? "mainColor" : "fixWh"))
                }
        })
        .shadow(radius: 1)
    }
}

#Preview {
    MyInfoBtn(type: .friend, selected: false) {
        
    }
}
