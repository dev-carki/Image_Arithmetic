//
//  PredictionResponseModel.swift
//  Image_Arithmetic
//
//  Created by Carki on 9/1/25.
//

import Foundation

struct PredictionResponseDTO: Codable {
    let prediction: Int
    let probabilities: [[Double]]
}

extension PredictionResponseDTO {
    func toPrediction() -> Prediction {
        return Prediction(predictionNumber: self.prediction.toString())
    }
}
