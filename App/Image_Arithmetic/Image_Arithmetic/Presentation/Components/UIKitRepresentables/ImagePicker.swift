//
//  ImagePicker.swift
//  Image_Arithmetic
//
//  Created by Carki on 9/1/25.
//

import SwiftUI
import UIKit

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?

    func makeCoordinator() -> ImagePickerCoordinator {
        ImagePickerCoordinator(self)
    }

    func makeUIViewController(context: Context) -> some UIViewController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}
