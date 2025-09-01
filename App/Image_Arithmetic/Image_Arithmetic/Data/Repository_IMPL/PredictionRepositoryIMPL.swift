//
//  PredictionRepositoryIMPL.swift
//  Image_Arithmetic
//
//  Created by Carki on 9/1/25.
//

import Foundation

final class PredictionRepositoryIMPL: PredictionRepository {
    let api: PredictionDataSource
    
    init(api: PredictionDataSource) {
        self.api = api
    }
    
    func getPredictionNumber(image: Data) async -> Result<Prediction, APIError> {
        let result = await api.getPredictionNumber(image: image)
        return result.map { dto in
            dto.toPrediction()
        }
    }
}
