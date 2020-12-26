//
//  ImagePicker.swift
//  SeeFood
//
//  Created by Justin Cheung on 12/24/20.
//

import SwiftUI
import UIKit

typealias PickedImageHandler = (UIImage?) -> Void

struct ImagePicker: UIViewControllerRepresentable {

    var sourceType: UIImagePickerController.SourceType

    var handlePickedImage: PickedImageHandler

    func makeUIViewController(context: Context) -> some UIViewController {
        let picker = UIImagePickerController()
        picker.sourceType = self.sourceType
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // TODO
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(handlePickedImage: self.handlePickedImage)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var handlePickedImage: PickedImageHandler

        init(handlePickedImage: @escaping PickedImageHandler) {
            self.handlePickedImage = handlePickedImage
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            self.handlePickedImage(info[.originalImage] as? UIImage)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            self.handlePickedImage(nil)
        }
    }
}
