//
//  PredictionEndpoint.swift
//  Image_Arithmetic
//
//  Created by Carki on 9/1/25.
//

import Foundation

class PredictionEndpoint {
    enum getPrediction: EndPoint {
        case getPrediction
        
        var url: String {
            switch self {
            case .getPrediction:
                return "/predict"
            }
        }
    }
}
