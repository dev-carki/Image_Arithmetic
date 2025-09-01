//
//  MainView.swift
//  Image_Arithmetic
//
//  Created by Carki on 8/27/25.
//

import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = MainViewModel()
    
    var body: some View {
        VStack {
            Text("MNIST Digit Predictor")
                .font(.title)
                .padding()
            
            if let image = viewModel.selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .border(Color.gray, width: 1)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 200, height: 200)
                    .overlay(Text("No Image"))
            }
            
            Button("Select Image") {
                viewModel.isShowingPicker = true
            }
            .padding()
            .buttonStyle(BorderedProminentButtonStyle())
            
            Button("Predict") {
                Task {
                    if let image = viewModel.selectedImage {
                        await viewModel.getPredictionNumber()
                    }
                }
            }
            .padding()
            .disabled(viewModel.selectedImage == nil)
            .buttonStyle(BorderedProminentButtonStyle())
            
            Text("Prediction: \(viewModel.prediction)")
                .font(.headline)
                .padding()
        }
        .sheet(isPresented: $viewModel.isShowingPicker) {
            ImagePicker(image: $viewModel.selectedImage)
        }
    }
    
    
}



#Preview {
    MainView()
}
