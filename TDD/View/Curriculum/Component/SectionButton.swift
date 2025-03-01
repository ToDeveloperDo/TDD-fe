//
//  SectionButton.swift
//  TDD
//
//  Created by 최안용 on 11/11/24.
//

import SwiftUI

struct SectionButton: View {
    var title: String
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Spacer()
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(isSelected ? .fixWh : .sectionTitleGray)
                Spacer()
            }
            .padding(.vertical, 8.5)
            .background(isSelected ? .black50 : .fixWh)
            .cornerRadius(10, corners: .allCorners)
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isSelected ? .clear : .black50)
            }
        }
    }
}

#Preview {
    SectionButton(title: "dk", isSelected: false, action: {})
}
