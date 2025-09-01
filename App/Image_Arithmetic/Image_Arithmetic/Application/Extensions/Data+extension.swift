//
//  Data+extension.swift
//  Image_Arithmetic
//
//  Created by Carki on 9/1/25.
//

import Foundation

// MARK: - Data Extension for Multipart
extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}
