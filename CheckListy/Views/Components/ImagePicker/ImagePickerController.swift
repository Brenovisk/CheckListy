//
//  ImagePickerController.swift
//  CheckListy
//
//  Created by Breno Lucas on 28/07/24.
//

import Foundation
import SwiftUI
import PhotosUI

struct ImagePickerController: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Binding var imageUrl: URL?
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePickerController
        
        init(_ parent: ImagePickerController) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
                
                if let imageData = uiImage.jpegData(compressionQuality: 0.8) {
                    let tempDirectory = FileManager.default.temporaryDirectory
                    let fileName = UUID().uuidString + ".jpg"
                    let fileURL = tempDirectory.appendingPathComponent(fileName)
                    
                    do {
                        try imageData.write(to: fileURL)
                        parent.imageUrl = fileURL
                    } catch {
                        print("Error saving image to URL: \(error)")
                    }
                }
            }
            picker.dismiss(animated: true)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}
