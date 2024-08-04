//
//  ImagePicker.swift
//  CheckListy
//
//  Created by Breno Lucas on 28/07/24.
//

import Foundation
import SwiftUI

struct ImagePicker: View {
    
    @State private var image: UIImage? = nil
    @State private var imageURL: URL?
    @State private var showImagePicker = false
    
    var onPick: ((UIImage) -> Void)?
    
    private init(image: UIImage?, onPick: ((UIImage) -> Void)?) {
        self.init(image: image)
        self.onPick = onPick
    }
    
    init(image: UIImage?) {
        _image = State(initialValue: image)
        self.imageURL = imageURL
        self.showImagePicker = showImagePicker
    }
    
    var body: some View {
        VStack {
            ZStack(alignment: .bottomTrailing){
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .profileImage(100)
                } else {
                    Circle()
                        .fill(Color.accentColor)
                        .profileImage(100)
                        .overlay(
                            Image(systemName: "camera.fill")
                                .colorInvert()
                        )
                }
                
                Image(systemName: "pencil.circle.fill")
                    .resizable()
                    .frame(width: 32, height: 32)
                    .foregroundColor(.black)
                    .background(.white)
                    .clipShape(Circle())
            }
            
        }
        .onTapGesture {
            showImagePicker = true
        }
        .padding()
        .sheet(isPresented: $showImagePicker) {
            ImagePickerController(image: $image, imageUrl: $imageURL)
        }
        .onChange(of: imageURL) {
            guard let image else { return }
            onPick?(image)
        }
    }
    
}

//MARK: - Callbacks modifiers
extension ImagePicker {
    
    func `onPick`(action: ((UIImage) -> Void)?) -> ImagePicker {
        ImagePicker(
            image: self.image,
            onPick: action
        )
    }
    
}


#Preview {
    ImagePicker(image: nil)
}
