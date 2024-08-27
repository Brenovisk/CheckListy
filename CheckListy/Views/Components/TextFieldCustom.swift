//
//  TextFieldCustom.swift
//  CheckListy
//
//  Created by Breno Lucas on 20/08/24.
//

import Foundation
import SwiftUI

struct TextFieldCustom: View {
    
    @Binding var text: String
    @State private var enableSecure: Bool = true
    @FocusState private var isFocused: Bool
    
    var placeholder: String = String()
    var helperText: String?
    var onChanged: (() -> Void)?
    var isSecureTextfield: Bool = false
    var isAutoFocused: Bool = false
    
    var showHelperText: Bool {
        helperText != nil && !isFocused
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Group {
                    if isAutoFocused && isSecureTextfield && enableSecure {
                        AutoFocusTextField(
                            text: $text,
                            placeholder: placeholder,
                            isSecureTextEntry: true
                        )
                    } else if isAutoFocused {
                        AutoFocusTextField(
                            text: $text,
                            placeholder: placeholder,
                            isSecureTextEntry: false
                        )
                    } else if isSecureTextfield && enableSecure {
                        SecureField(placeholder, text: $text)
                    } else {
                        TextField(placeholder, text: $text)
                    }
                }
                .focused($isFocused)
                .autocapitalization(.none)
                
                if isSecureTextfield {
                    Button(action: {
                        enableSecure.toggle()
                    }) {
                        Image(systemName: enableSecure ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .roundedBackgroundTextField()
            .padding(.vertical, 4)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isFocused ? Color.green : (!showHelperText ? Color.clear : .red), lineWidth: 1)
                    .transition(.opacity)
                    .animation(.easeInOut, value: helperText)
            )
            .cornerRadius(8)
            
            if showHelperText {
                Text(helperText ?? String())
                    .font(.caption)
                    .foregroundColor(.red)
                    .transition(.opacity)
                    .animation(.easeInOut, value: helperText)
                    .padding(.top, 4)
            }
        }
        .onChange(of: text) {
            onChanged?()
        }
    }
    
}
