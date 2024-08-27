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
        VStack(spacing: .zero) {
            logo
                .slideOnAppear(delay: 0.4, direction: .fromLeft)
            
            Texts.slogan.value
                .font(.body)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 12)
                .slideOnAppear(delay: 0.4, direction: .fromLeft)
            
            Button(action: { onStart?() }) {
                Texts.start.value
                    .frame(maxWidth: .infinity)
            }
            .filledButton()
            .padding(.top, 32)
            .slideOnAppear(delay: 0.6, direction: .fromBottom)
            
            footer
                .padding(.top, 16)
                .slideOnAppear(delay: 0.6, direction: .fromBottom)
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 32)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .background {
            backgroundImage
        }
    }
    
    var logo: some View {
        VStack(alignment: .leading, spacing: 24) {
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
        VStack {
            Rectangle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(stops: [
                            .init(color: Colors.background.value.opacity(0), location: 0),
                            .init(color: Colors.background.value.opacity(1), location: 0.57)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
        }
        .background(
            VStack {
                Images.photoBackground.image
                    .resizable()
                    .scaledToFit()
                    .opacityOnAppear(delay: 0.6, duration: 0.8)
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .background(Colors.background.value)
            .ignoresSafeArea()
        )
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

// MARK: typealias
extension StartView {
    
    typealias Colors = ColorsHelper
    typealias Images = ImagesHelper
    typealias Texts  = TextsHelper
    
}

#Preview {
    StartView()
}
