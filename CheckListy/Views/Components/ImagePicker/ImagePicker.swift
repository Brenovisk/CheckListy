//
//  ImagePicker.swift
//  CheckListy
//
//  Created by Breno Lucas on 28/07/24.
//

import Foundation
import SwiftUI

struct ImagePicker: View {
    
    @State private var image: UIImage?
    @State private var imageURL: URL?
    @State private var showImagePicker = false
    
    var onPick: ((UIImage) -> Void)?
    
    private init(onPick: ((UIImage) -> Void)?) {
        self.init()
        self.onPick = onPick
    }
    
     init() {
        self.image = image
        self.imageURL = imageURL
        self.showImagePicker = showImagePicker
    }

    var body: some View {
        VStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 64)
                    .clipShape(Circle())
            } else {
                Circle()
                    .fill(Color.gray)
                    .frame(height: 64)
                    .overlay(
                        Image(systemName: "camera")
                            .colorInvert()
                    )
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
            onPick: action
        )
    }
    
}


#Preview {
    ImagePicker()
}
