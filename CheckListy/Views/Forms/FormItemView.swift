//
//  FormItemView.swift
//  CheckListy
//
//  Created by Breno Lucas on 10/07/24.
//

import Foundation
import SwiftUI

struct FormItemView: View, KeyboardReadable {
    
    @Binding var item: ListItemModel?
    
    @State private var id: UUID
    @State private var description: String
    @State private var section: String
    @State private var name: String
    @State private var isCheck: Bool
    @State private var sheetHeight: CGFloat = .zero
    @State private var isActionButton: Bool = false
    
    var onSave: ((ListItemModel) -> Void)?
    var onClose: (() -> Void)?
    
    private init(item: Binding<ListItemModel?>, section: Binding<String> = Binding.constant(String()), onSave: ((ListItemModel) -> Void)?, onClose: (() -> Void)?) {
        self.init(item: item, section: section)
        self.onSave = onSave
        self.onClose = onClose
    }
    
    init(item: Binding<ListItemModel?>, section: Binding<String> = Binding.constant(String())) {
        self._item = item
        _id = State(initialValue: item.wrappedValue?.id ?? UUID())
        _name = State(initialValue: item.wrappedValue?.name ?? String())
        _description = State(initialValue: item.wrappedValue?.description ?? String())
        _section = State(initialValue: !section.wrappedValue.isEmpty ? section.wrappedValue : (item.wrappedValue?.section ?? String()))
        _isCheck = State(initialValue: item.wrappedValue?.isCheck ?? false)
        
        UITextField.appearance().clearButtonMode = .whileEditing
    }
    
    var body: some View {
        VStack {
            HStack {
                AutoFocusTextField(text: $name, placeholder: "Nome do Item")
                    .roundedBackgroundTextField()
                
                if isActionButton || item != nil {
                    Button(action: {
                        let item = ListItemModel(
                            id: id,
                            name: name,
                            description: description,
                            section: section,
                            isCheck: isCheck
                        )
                        
                        onSave?(item)
                        onClose?()
                    }) {
                        Image(systemName: item == nil ? "plus" : "checkmark")
                            .foregroundColor(Color(uiColor: .systemBlue))
                            .font(.title)
                    }
                }
            }.padding(.bottom, 8)
            
            TextField("Descrição do Item", text: $description)
                .roundedBackgroundTextField()
                .padding(.bottom, 8)
            
            TextField("Seção do Item", text: $section)
                .roundedBackgroundTextField()
                .padding(.bottom, 8)
        }
        .padding(.horizontal, 16)
        .overlay {
            GeometryReader { geometry in
                Color.clear
                    .preference(key: InnerHeightPreferenceKey.self, value: geometry.size.height)
            }
        }
        .onPreferenceChange(InnerHeightPreferenceKey.self) { newHeight in
            sheetHeight = newHeight
        }
        .presentationDetents([.height(sheetHeight)])
        .onReceive(keyboardPublisher) { value in
            if !value {
                onClose?()
            }
        }
        .onChange(of: name) {
            withAnimation {
                isActionButton = !name.isEmpty
            }
        }
    }
}

struct InnerHeightPreferenceKey: PreferenceKey {
    
    static let defaultValue: CGFloat = .zero
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
    
}

// MARK: - Callbacks modifiers
extension FormItemView {
    
    func `onSave`(action: ((ListItemModel) -> Void)?) -> FormItemView {
        FormItemView(
            item: self.$item,
            section: self.$section,
            onSave: action,
            onClose: self.onClose
        )
    }
    
    func `onClose`(action: (() -> Void)?) -> FormItemView {
        FormItemView(
            item: self.$item,
            section: self.$section,
            onSave: self.onSave,
            onClose: action
        )
    }
    
}

#Preview {
    NavigationView {
        FormItemView(item: Binding.constant(nil))
    }
}
