//
//  PredictionDataSource.swift
//  Image_Arithmetic
//
//  Created by Carki on 9/1/25.
//

import Foundation

protocol PredictionDataSource {
    func getPredictionNumber(image: Data) async -> Result<PredictionResponseDTO, APIError>
}
