//
//  TodoInputView.swift
//  TDD
//
//  Created by 최안용 on 7/30/24.
//

import SwiftUI

struct TodoInputView: View {
    @EnvironmentObject var viewModel: CalendarViewModel
    @StateObject var todoInputViewModel: TodoInputViewModel
    @FocusState private var focusedField: Field?
    @State private var keyboardHeight: CGFloat = 0
    @State var isPresent: Bool = false
    @State private var isEdit: Bool = true
    
    enum Field {
        case title
        case tag
        case memo
    }
    
    var body: some View {
        VStack {
            TodoTitleView(todoInputViewModel: todoInputViewModel)
                .focused($focusedField, equals: .title)
                .submitLabel(.next)
                .onSubmit {
                    focusedField = .memo
                }
                .onAppear {
                    focusedField = .title
                }
            
            TodoMemoView(todoInputViewModel: todoInputViewModel)
                .focused($focusedField, equals: .memo)
                .onSubmit {
                    focusedField = .tag
                }
            
            TagView(todoInputViewModel: todoInputViewModel,
                    focusedField: $focusedField, isEdit: $isEdit)
                .focused($focusedField, equals: .tag)
                .submitLabel(.return)
                .onSubmit {
                    focusedField = nil
                    isPresent = true
                }
            
            BottomView(todoInputViewModel: todoInputViewModel, isPresent: $isPresent)
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .padding(.bottom, keyboardHeight)
        .background(Color.fixWh)
        .cornerRadius(10)
        .alert("업로드 확인", isPresented: $isPresent) {
            Button(role: .cancel) {
                viewModel.send(action: .createTodo(todo: todoInputViewModel.todo))
            } label: {
                Text("확인")
            }
            Button(role: .destructive) {
                focusedField = .title
            } label: {
                Text("취소")
            }
        } message: {
            Text("GitHub에 업로드 하시겠습니까?")
        }
        .onAppear {
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification,
                                                   object: nil,
                                                   queue: .main) { notification in
                if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                    keyboardHeight = keyboardFrame.height
                }
            }
        }
        .animation(.linear, value: keyboardHeight)
    }
}

private struct TodoTitleView: View {
    @ObservedObject private var todoInputViewModel: TodoInputViewModel
    
    fileprivate init(todoInputViewModel: TodoInputViewModel) {
        self.todoInputViewModel = todoInputViewModel
    }
    
    fileprivate var body: some View {
        TextField("어떤 일을 하시겠습니까?", text: $todoInputViewModel.todo.content)
            .padding(.horizontal, 3)
    }
}

private struct TodoMemoView: View {
    @ObservedObject private var todoInputViewModel: TodoInputViewModel
    @State private var textHeight: CGFloat = 16  // 텍스트 높이 초기 값
    
    fileprivate init(todoInputViewModel: TodoInputViewModel) {
        self.todoInputViewModel = todoInputViewModel
    }
    
    fileprivate var body: some View {
        ZStack(alignment: .leading) {
            TextViewWrapper(text: $todoInputViewModel.todo.memo, calculatedHeight: $textHeight)
                .frame(height: min(textHeight, 5 * UIFont.systemFont(ofSize: 16).lineHeight))
                .clipShape(Rectangle())
            
            
            if todoInputViewModel.todo.memo.isEmpty {
                Text("설명")
                    .font(.system(size: 16))
                    .foregroundColor(.gray.opacity(0.6))
                    .allowsHitTesting(false)
                    .padding(.top, 2)
                    .padding(.leading, 5)
            }
        }
    }
}

private struct TextViewWrapper: UIViewRepresentable {
    @Binding var text: String
    @Binding var calculatedHeight: CGFloat
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isScrollEnabled = false  // 초기에는 스크롤 비활성화
        textView.isEditable = true
        textView.backgroundColor = .clear
        textView.font = .systemFont(ofSize: 16)
        textView.delegate = context.coordinator
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
        TextViewWrapper.recalculateHeight(view: uiView, result: $calculatedHeight)
        uiView.isScrollEnabled = calculatedHeight > 5 * uiView.font!.lineHeight
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: TextViewWrapper
        
        init(parent: TextViewWrapper) {
            self.parent = parent
        }
        
        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
            TextViewWrapper.recalculateHeight(view: textView, result: parent.$calculatedHeight)
        }
    }
    
    static func recalculateHeight(view: UITextView, result: Binding<CGFloat>) {
        let size = view.sizeThatFits(CGSize(width: view.frame.width, height: CGFloat.greatestFiniteMagnitude))
        if result.wrappedValue != size.height {
            DispatchQueue.main.async {
                result.wrappedValue = size.height
            }
        }
    }
}

private struct TagView: View {
    @ObservedObject private var todoInputViewModel: TodoInputViewModel
    @Binding private var isEdit: Bool
    
    private var focusedField: FocusState<TodoInputView.Field?>.Binding
    
    
    fileprivate init(todoInputViewModel: TodoInputViewModel,
                     focusedField: FocusState<TodoInputView.Field?>.Binding,
                     isEdit: Binding<Bool>) {
        self.todoInputViewModel = todoInputViewModel
        self.focusedField = focusedField
        self._isEdit = isEdit
    }
    
    var body: some View {
        Group {
            if todoInputViewModel.todo.tag.isEmpty || isEdit {
                TextField("태그", text: $todoInputViewModel.todo.tag)
                    .onChange(of: focusedField.wrappedValue) { oldValue, newValue in
                        if newValue != .tag {
                            isEdit = false
                        } else {
                            isEdit = true
                        }
                    }
            } else {
                HStack {
                    Button(action: {
                        todoInputViewModel.todo.tag = ""
                        focusedField.wrappedValue = .tag
                    }, label: {
                        HStack {
                            Image(.icTag)
                                .resizable()
                                .renderingMode(.template)
                                .aspectRatio(contentMode: .fit)
                                .foregroundStyle(.fixWh)
                                .frame(width: 15)
                            Text("\(todoInputViewModel.todo.tag)")
                                .foregroundStyle(.fixWh)
                        }
                        .padding(3)
                        .background(RoundedRectangle(cornerRadius: 5).fill(.green))
                        
                    })
                    Spacer()
                }.onAppear {
                    focusedField.wrappedValue = .memo
                }
            }
        }
        .padding(.horizontal, 4)
    }
}

private struct BottomView: View {
    @EnvironmentObject var viewModel: CalendarViewModel
    @ObservedObject private var todoInputViewModel: TodoInputViewModel
    @Binding var isPresent: Bool
    fileprivate init(todoInputViewModel: TodoInputViewModel, isPresent: Binding<Bool>) {
        self.todoInputViewModel = todoInputViewModel
        self._isPresent = isPresent
    }
    
    fileprivate var body: some View {
        HStack {
            Label {
                Text("\(todoInputViewModel.todo.deadline)")
            } icon: {
                Image(.icCalendar)
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 20, height: 20)
                    .foregroundStyle(Color.red)
            }
            
            Spacer()
            
            Button(action: {
                isPresent = true
            }, label: {
                Image(.icUparrow)
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 30, height: 30)
                    .foregroundStyle(Color.fixWh)
                    .padding(1)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .foregroundStyle(Color.red)
                    )
            })
            .overlay {
                if todoInputViewModel.todo.content.isEmpty || todoInputViewModel.todo.tag.isEmpty{
                    Color.white.opacity(0.5).clipShape(Circle())
                }
            }
            .disabled(todoInputViewModel.todo.content.isEmpty || todoInputViewModel.todo.tag.isEmpty)
        }
        .padding(.vertical, 5)
    }
}


#Preview {
    TodoInputView(todoInputViewModel:.init(todo: .init(content: "", memo: "", tag: "", deadline: "2049-02-31", status: .PROCEED)))
        .environmentObject(CalendarViewModel(container: .stub))
}
