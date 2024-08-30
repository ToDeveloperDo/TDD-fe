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
        VStack(spacing: 0) {
            HeaderView(todoInputViewModel: todoInputViewModel)
                .padding(.bottom, 6)
            
            TodoTitleView(todoInputViewModel: todoInputViewModel)
                .focused($focusedField, equals: .title)
                .submitLabel(.next)
                .onSubmit {
                    focusedField = .memo
                }
                .onAppear {
                    focusedField = .title
                }
            
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(.fixBk.opacity(0.2))
                .padding(.bottom, 4)
            
            TodoMemoView(todoInputViewModel: todoInputViewModel)
                .focused($focusedField, equals: .memo)
                .onSubmit {
                    focusedField = .tag
                }
            
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(.fixBk.opacity(0.2))
                .padding(.bottom, 4)
            
            TagView(todoInputViewModel: todoInputViewModel,
                    focusedField: $focusedField, isEdit: $isEdit)
                .focused($focusedField, equals: .tag)
                .submitLabel(.return)
                .onSubmit {
                    focusedField = nil
                    isPresent = true
                }
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(.fixBk.opacity(0.2))
            
            BottomView(todoInputViewModel: todoInputViewModel) {
                focusedField = nil
                isPresent = true
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 32)
        .padding(.bottom, keyboardHeight)
        .background(Color.fixWh)
        .cornerRadius(20)
        .alert("업로드 확인", isPresented: $isPresent) {
            Button(role: .cancel) {
                viewModel.send(action: .createTodo(todoInputViewModel.todo))
            } label: {
                Text("확인")
            }
            Button(role: .destructive) {
                focusedField = .title
            } label: {
                Text("취소")
            }
        } message: {
            Text("업로드 하시겠습니까?")
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

private struct HeaderView: View {
    @ObservedObject var todoInputViewModel: TodoInputViewModel
    
    var body: some View {
        HStack {
            Text("\(todoInputViewModel.dateStr)")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.fixBk)
                
            Spacer()
        }
    }
}

private struct TodoTitleView: View {
    @ObservedObject private var todoInputViewModel: TodoInputViewModel
    
    fileprivate init(todoInputViewModel: TodoInputViewModel) {
        self.todoInputViewModel = todoInputViewModel
    }
    
    fileprivate var body: some View {
        TextField("", text: $todoInputViewModel.todo.content,
                  prompt: Text("어떤 일을 하시겠습니까?")
            .font(.system(size: 14, weight: .thin))
            .foregroundStyle(.fixBk.opacity(0.2))
        )
        .font(.system(size: 14, weight: .thin))
        .foregroundStyle(.fixBk)
        .padding(.horizontal, 3)
        .padding(.vertical, 8)
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
                .frame(height: min(textHeight, 5 * UIFont.systemFont(ofSize: 14).lineHeight))
                .clipShape(Rectangle())
            
            
            if todoInputViewModel.todo.memo.isEmpty {
                Text("설명을 입력해주세요")
                    .font(.system(size: 14, weight: .thin))
                    .foregroundStyle(.fixBk.opacity(0.2))
                    .allowsHitTesting(false)
                    .padding(.vertical, 8)
                    .padding(.leading, 3)
                    
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
        textView.font = .systemFont(ofSize: 14, weight: .thin)
        textView.textColor = .fixBk
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
                TextField("",
                          text: $todoInputViewModel.todo.tag,
                          prompt: Text("태그를 입력해주세요")
                    .font(.system(size: 14, weight: .thin))
                    .foregroundStyle(.fixBk.opacity(0.2))
                )
                .font(.system(size: 14, weight: .thin))
                .foregroundStyle(.fixBk)
                .padding(.vertical, 8)
                .onChange(of: focusedField.wrappedValue) { oldValue, newValue in
                    if newValue != .tag {
                        isEdit = false
                    } else {
                        isEdit = true
                    }
                }
            } else {
                HStack {
                    TagBtn(action: {
                        todoInputViewModel.todo.tag = ""
                        focusedField.wrappedValue = .tag
                    }, title: "\(todoInputViewModel.todo.tag)")
                    .padding(.top, 4)
                    .padding(.bottom, 2)
                    Spacer()
                }.onAppear {
                    focusedField.wrappedValue = .memo
                }
            }
        }
        .padding(.horizontal, 3)
    }
}

private struct BottomView: View {
    @EnvironmentObject var viewModel: CalendarViewModel
    @ObservedObject private var todoInputViewModel: TodoInputViewModel
    
    var btnAction: () -> Void
    
    fileprivate init(todoInputViewModel: TodoInputViewModel, btnAction: @escaping () -> Void) {
        self.todoInputViewModel = todoInputViewModel
        self.btnAction = btnAction
    }
    
    fileprivate var body: some View {
        HStack {
            Spacer()
            
            Button(action: {
                btnAction()
            }, label: {
                Image(.icInputarrow)
                    .resizable()
                    .frame(width: 29, height: 29)
            })
            .overlay {
                if todoInputViewModel.todo.content.isEmpty || todoInputViewModel.todo.tag.isEmpty{
                    Color.white.opacity(0.5).clipShape(Circle())
                }
            }
            .disabled(todoInputViewModel.todo.content.isEmpty || todoInputViewModel.todo.tag.isEmpty)
        }
        .padding(.vertical, 11)
    }
}


#Preview {
    TodoInputView(todoInputViewModel:.init(todo: .init(content: "", memo: "", tag: "디자인", deadline: "2049-02-31", status: .PROCEED), date: Date()))
        .environmentObject(CalendarViewModel(container: .stub))
}
