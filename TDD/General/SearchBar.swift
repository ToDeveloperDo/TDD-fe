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
                .clearButton(text: $text)
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
        .padding(.vertical, 1)
        .background(Color.mainbg)
    }
}

struct ClearButton: ViewModifier {
    @Binding var text: String
    
    func body(content: Content) -> some View {
        HStack {
            content
            
            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle")
                        .foregroundStyle(.daycellGray2)
                }
                .padding(.trailing, 10)

            }
        }
    }
}

extension View {
    func clearButton(text: Binding<String>) -> some View {
        modifier(ClearButton(text: text))
    }
}

#Preview {
    SearchBar(text: .constant("dk"), action: {})
}
