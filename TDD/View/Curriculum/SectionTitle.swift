//
//  SectionTitle.swift
//  TDD
//
//  Created by 최안용 on 11/11/24.
//

import SwiftUI

struct SectionTitle: View {
    let section: SectionInfo
    var isSelected: Bool
    var selectedItem: String
    
    var body: some View {
        HStack {
            Spacer()
            Text(isSelected ? "\(selectedItem)" : section.rawValue)
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(isSelected ? .fixWh : .sectionTitleGray)
            Spacer()
        }
        .padding(.vertical, 27)
        .background(isSelected ? .main : .fixWh)
        .cornerRadius(10, corners: .allCorners)
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(isSelected ? .clear : .sectionBorder)
        }                
    }
}

#Preview {
    SectionTitle(section: .level, isSelected: true, selectedItem: "dk")
}
