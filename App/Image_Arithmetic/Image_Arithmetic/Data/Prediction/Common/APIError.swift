//
//  APIError.swift
//  Image_Arithmetic
//
//  Created by Carki on 9/1/25.
//

import Foundation

enum APIError: String, Error {
    case UNKNOWN
    case PARSING
    case AFERROR
    
    func toNetworkError() -> NetworkError {
        NetworkError(rawValue: self.rawValue) ?? NetworkError.UNKNOWN
    }
}
