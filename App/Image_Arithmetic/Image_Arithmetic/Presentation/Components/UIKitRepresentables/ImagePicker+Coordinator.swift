//
//  ImagePicker+Coordinator.swift
//  Image_Arithmetic
//
//  Created by Carki on 9/1/25.
//

import UIKit

class ImagePickerCoordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let parent: ImagePicker

    init(_ parent: ImagePicker) {
        self.parent = parent
    }

    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        if let uiImage = info[.originalImage] as? UIImage {
            parent.image = uiImage
        }
        picker.dismiss(animated: true)
    }
}
