//
//  StartView.swift
//  CheckListy
//
//  Created by Breno Lucas on 19/08/24.
//

import SwiftUI

struct StartView: View {
    
    var onStart: (() -> Void)?
    var onRegister: (() -> Void)?
    
    private init(onStart: (() -> Void)?, onRegister: (() -> Void)?) {
        self.onStart = onStart
        self.onRegister = onRegister
    }
    
    init() {}
    
    var body: some View {
        ZStack {
            backgroundImage
            
            VStack(spacing:.zero) {
                Spacer()
                
                logo
                
                Texts.slogan.value
                    .font(.body)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 12)
                
                Button(action: { onStart?() }) {
                    Texts.start.value
                        .frame(maxWidth: .infinity)
                }
                .filledButton()
                .padding(.top, 32)
                
                footer
                    .padding(.top, 16)

            }
            .padding(.horizontal, 16)
            .padding(.bottom, 32)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
    }
    
    var logo: some View {
        VStack(alignment: .leading, spacing: 24){
            Images.logo.image
                .resizable()
                .frame(width: 80, height: 80)
            
            Images.logoName.image
                .resizable()
                .frame(width: 199, height: 116)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var backgroundImage: some View {
        ZStack {
            VStack {
                Images.photoBackground.image
                    .resizable()
                    .scaledToFit()
            }.frame(maxHeight: .infinity, alignment: .top)
            
            Rectangle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(stops: [
                            .init(color:Colors.background.value.opacity(0), location: 0),
                            .init(color:Colors.background.value.opacity(1), location: 0.57)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
        }
        .ignoresSafeArea()
        .background(Colors.background.value)
    }
    
    
    var footer: some View {
        HStack {
            Texts.notHaveAccount.value
                .foregroundColor(.white)
            
            Button(action: { onRegister?() }) {
                Texts.registerYourSelf.value
                    .foregroundColor(.accentColor)
            }
        }
    }
    
}

// MARK: - StartView modifiers
extension StartView {
    
    func `onStart`(action: (() -> Void)?) -> StartView {
        StartView(
            onStart: action,
            onRegister: self.onRegister
        )
    }
    
    func `onRegister`(action: (() -> Void)?) -> StartView {
        StartView(
            onStart: self.onStart,
            onRegister: action
        )
    }
    
}

//MARK: typealias
extension StartView {
    
    typealias Colors = ColorsHelper
    typealias Images = ImagesHelper
    typealias Texts  = TextsHelper
    
}

#Preview {
    StartView()
}
