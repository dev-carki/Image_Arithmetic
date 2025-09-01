//
//  PredictionRepository.swift
//  Image_Arithmetic
//
//  Created by Carki on 9/1/25.
//

import Foundation

protocol PredictionRepository {
    func getPredictionNumber(image: Data) async -> Result<Prediction, APIError>
}
