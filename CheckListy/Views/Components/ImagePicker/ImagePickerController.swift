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
    @Binding var imageURL: URL?

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: ImagePicker

        init(parent: ImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)

            guard let provider = results.first?.itemProvider else { return }

            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { (image, error) in
                    DispatchQueue.main.async {
                        self.parent.image = image as? UIImage
                    }
                }
            }

            provider.loadFileRepresentation(forTypeIdentifier: "public.image") { (url, error) in
                DispatchQueue.main.async {
                    self.parent.imageURL = url
                }
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
}
