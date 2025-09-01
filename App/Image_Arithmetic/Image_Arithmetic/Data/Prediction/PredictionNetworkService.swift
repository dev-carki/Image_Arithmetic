//
//  PredictionNetworkService.swift
//  Image_Arithmetic
//
//  Created by Carki on 9/1/25.
//

import UIKit

import Alamofire
import Factory

final class PredictionNetworkService: BaseNetworkService {
    func get<T>(_ host: String, url: String, image: Data) async -> Result<T, APIError> where T: Codable {
        
        await upload(host, url: url, fileData: image).mapError { apiError in
            self.decodeError()
        }
    }
    
    //TODO: 에러 핸들링
    private func decodeError() -> APIError {
        return APIError.UNKNOWN
    }
}
