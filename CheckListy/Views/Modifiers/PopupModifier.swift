//
//  PopupModifier.swift
//  CheckListy
//
//  Created by Breno Lucas on 20/08/24.
//

import Foundation
import SwiftUI
import PopupView

struct PopupModifier: ViewModifier {
    
    var data: PopupData
    var isPresent: Binding<Bool>
    
    func body(content: Content) -> some View {
        GeometryReader { geometry in
            content
                .popup(isPresented: isPresent){
                    popupContent
                        .padding(.bottom, geometry.safeAreaInsets.bottom + 50)
                } customize: {
                    $0
                        .type(.toast)
                        .position(.bottom)
                        .animation(.spring())
                        .closeOnTapOutside(true)
                        .autohideIn(3)
                }
        }
    }
    
    var popupContent: some View {
        HStack(spacing: 8){
            data.type.value.icon
                .resizable()
                .frame(width: 16, height: 16)
                .fontWeight(.bold)
            
            Text(data.message)
                .lineLimit(2)
                
        }
        .padding()
        .foregroundColor(Color.black)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(data.type.value.color)
        .cornerRadius(12)
    }
    
}

extension View {
    
    func popup(isPresent: Binding<Bool>, data: PopupData) -> some View {
        modifier(PopupModifier(data: data, isPresent: isPresent))
    }
    
}

