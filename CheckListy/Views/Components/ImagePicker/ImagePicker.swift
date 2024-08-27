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
    var size: CGFloat = 100
    
    private init(image: UIImage?, size: CGFloat = 100, onPick: ((UIImage) -> Void)?) {
        self.init(image: image, size: size)
        self.onPick = onPick
    }
    
    init(image: UIImage?, size: CGFloat = 100) {
        _image = State(initialValue: image)
        self.imageURL = imageURL
        self.showImagePicker = showImagePicker
        self.size = size
    }
    
    var body: some View {
        VStack {
            ZStack(alignment: .bottomTrailing){
                Group {
                    if let image = image {
                        Image(uiImage: image)
                            .resizable()
                    } else {
                        Circle()
                            .fill(Color(uiColor: UIColor.gray))
                            .overlay(
                                Image(systemName: "camera.fill")
                                    .scaleEffect(2.5)
                            )
                    }
                }
                .profileImage(size)
                
                Image(systemName: "pencil.circle.fill")
                    .resizable()
                    .frame(width: 32, height: 32)
                    .foregroundColor(Color.accentColor)
                    .background(.white)
                    .clipShape(Circle())
            }
            
        }
        .onTapGesture {
            showImagePicker = true
        }
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
            size: self.size,
            onPick: action
        )
    }
    
}


#Preview {
    HStack {
        ImagePicker(image: nil)
    }
    .frame(maxWidth: .infinity)
    .background(.black)
}
