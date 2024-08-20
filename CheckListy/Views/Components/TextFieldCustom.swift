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
    @State var enableSecure: Bool = true
    
    @FocusState private var isFocused: Bool

    var placeholder: String = String()
    var isSecureTextfield: Bool = false

    var body: some View {
        HStack {
            if isSecureTextfield && enableSecure {
                SecureField(placeholder, text: $text)
                    .padding()
                    .focused($isFocused)
            } else {
                TextField(placeholder, text: $text)
                    .padding()
                    .focused($isFocused)
            }
            
            if isSecureTextfield {
                Button(action: {
                    enableSecure.toggle()
                }) {
                    Image(systemName: enableSecure ? "eye.slash.fill" : "eye.fill")
                        .foregroundColor(.gray)
                }
                .padding(.trailing, 16)
            }
        }
        .roundedBackgroundTextField()
    }
    
}
