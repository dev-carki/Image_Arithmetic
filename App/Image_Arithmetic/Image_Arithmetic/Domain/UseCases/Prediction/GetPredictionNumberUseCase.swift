//
//  GetPredictionNumberUseCase.swift
//  Image_Arithmetic
//
//  Created by Carki on 9/1/25.
//

import Foundation

final class GetPredictionNumberUseCase {
    let repository: PredictionRepository
    
    init(repository: PredictionRepository) {
        self.repository = repository
    }
    
    func execute(image: Data) async -> String {
        let result = await self.repository.getPredictionNumber(image: image)
        
        switch result {
        case .success(let response):
            return response.predictionNumber
        case .failure(let error):
            print("Network Request Error!")
            print("Message: \(error.rawValue)")
            
            return error.rawValue
        }
    }
}
