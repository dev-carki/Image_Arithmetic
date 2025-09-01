//
//  MainViewModel.swift
//  Image_Arithmetic
//
//  Created by Carki on 9/1/25.
//

import SwiftUI

import Factory

final class MainViewModel: ObservableObject {
    @Injected(\.getPredictionNumberUseCase) private var getPredictionNumberUseCase
    
    @Published var selectedImage: UIImage? = nil
    @Published var prediction: String = ""
    @Published var isShowingPicker = false
    
    @MainActor
    func getPredictionNumber() async {
        if let image = selectedImage {
            guard let imageData = image.pngData() else { return }
            
            self.prediction = await getPredictionNumberUseCase.execute(image: imageData)
        }
    }
}
