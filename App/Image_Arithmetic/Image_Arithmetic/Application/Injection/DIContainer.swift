//
//  DIContainer.swift
//  Image_Arithmetic
//
//  Created by Carki on 9/1/25.
//

import Foundation

import Factory

extension Container {
    var networkService: Factory<BaseNetworkService> {
        Factory(self) { BaseNetworkService() }
    }
}

// MARK: Network
extension Container {
    var predictionNetworkService: Factory<PredictionNetworkService> {
        Factory(self) { PredictionNetworkService() }
    }
    var predictionDataSource: Factory<PredictionDataSource> {
        Factory(self) { PredictionDataSourceIMPL(host: "http://127.0.0.1:8000", networkService: self.predictionNetworkService()) }
    }
}

// MARK: Repository
extension Container {
    var predictionRepository: Factory<PredictionRepository> {
        Factory(self) { PredictionRepositoryIMPL(api: self.predictionDataSource()) }
    }
}

// MARK: UseCase
extension Container {
    var getPredictionNumberUseCase: Factory<GetPredictionNumberUseCase> {
        Factory(self) { GetPredictionNumberUseCase(repository: self.predictionRepository()) }
    }
}
