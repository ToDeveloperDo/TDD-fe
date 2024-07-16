//
//  UnKnownView.swift
//  TDD
//
//  Created by 최안용 on 7/11/24.
//

import SwiftUI

struct ContentView: View {
    @State private var text: String = ""
    @State private var showTextField: Bool = false
    @FocusState private var isTextFieldFocused: Bool

    var body: some View {
        VStack {
            Spacer()
            
            Button("Activate Keyboard") {
                showTextField = true

                    isTextFieldFocused = true

            }
            .padding()
            
            if showTextField {
                TextField("Enter text here", text: $text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .focused($isTextFieldFocused)
                    .background(
                        GeometryReader { geometry in
                            Color.clear
                                .preference(key: TextFieldOffsetKey.self, value: geometry.frame(in: .global).origin.y)
                        }
                    )
            }
        }
        .padding(.bottom, keyboardHeight)
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
        .onDisappear {
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        }
        .onPreferenceChange(TextFieldOffsetKey.self) { value in
            // 필요시 추가 로직 작성
        }
    }
    
    @State private var keyboardHeight: CGFloat = 0
}

struct TextFieldOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
