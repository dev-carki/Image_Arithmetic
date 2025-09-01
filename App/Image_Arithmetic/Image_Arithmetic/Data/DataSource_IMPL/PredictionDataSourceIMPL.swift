//
//  PredictionDataSourceIMPL.swift
//  Image_Arithmetic
//
//  Created by Carki on 9/1/25.
//

import Foundation

final class PredictionDataSourceIMPL: PredictionDataSource {
    let host: String
    let networkService: PredictionNetworkService
    
    init(host: String, networkService: PredictionNetworkService) {
        self.host = host
        self.networkService = networkService
    }
    
    func getPredictionNumber(image: Data) async -> Result<PredictionResponseDTO, APIError> {
        await self.networkService.get(self.host, url: PredictionEndpoint.getPrediction.getPrediction.url, image: image)
    }
}
