//
//  SearchBar.swift
//  TDD
//
//  Created by 최안용 on 8/14/24.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    private var action: () -> Void
    
    init(text: Binding<String>, action: @escaping () -> Void) {
        self._text = text
        self.action = action
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Image(.search)
            TextField("계정 검색하기", text: $text)
                .submitLabel(.search)
                .onSubmit {
                    action()
                }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background {
            RoundedRectangle(cornerRadius: 14)
                .foregroundStyle(Color.fixWh)
                .shadow(radius: 1)
        }
    }
}

#Preview {
    SearchBar(text: .constant("dk"), action: {})
}
