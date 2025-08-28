//
//  ContentView.swift
//  Image_Arithmetic
//
//  Created by Carki on 8/27/25.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedImage: UIImage? = nil
    @State private var prediction: String = ""
    @State private var isShowingPicker = false
    
    var body: some View {
        VStack {
            Text("MNIST Digit Predictor")
                .font(.title)
                .padding()
            
            if let image = selectedImage {
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
                isShowingPicker = true
            }
            .padding()
            
            Button("Predict") {
                if let image = selectedImage {
                    uploadImage(image: image)
                }
            }
            .padding()
            .disabled(selectedImage == nil)
            
            Text("Prediction: \(prediction)")
                .font(.headline)
                .padding()
        }
        .sheet(isPresented: $isShowingPicker) {
            ImagePicker(image: $selectedImage)
        }
    }
    
    // MARK: - Upload Function
    func uploadImage(image: UIImage) {
        guard let url = URL(string: "http://127.0.0.1:8000/predict") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        // 이미지 -> PNG 데이터 변환
        guard let imageData = image.pngData() else { return }
        
        var body = Data()
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"digit.png\"\r\n")
        body.append("Content-Type: image/png\r\n\r\n")
        body.append(imageData)
        body.append("\r\n")
        body.append("--\(boundary)--\r\n")
        
        request.httpBody = body
        
        // 네트워크 요청
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let result = try? JSONDecoder().decode(PredictionResponse.self, from: data) {
                    DispatchQueue.main.async {
                        self.prediction = "\(result.prediction)"
                    }
                }
            }
        }.resume()
    }
}

// MARK: - Response Model
struct PredictionResponse: Codable {
    let prediction: Int
    let probabilities: [[Double]]
}

// MARK: - Image Picker
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            picker.dismiss(animated: true)
        }
    }
}

// MARK: - Data Extension for Multipart
extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}


#Preview {
    ContentView()
}
