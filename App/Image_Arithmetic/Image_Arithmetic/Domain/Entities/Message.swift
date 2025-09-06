//
//  Message.swift
//  Image_Arithmetic
//
//  Created by Carki on 9/6/25.
//

import Foundation

struct Message: Identifiable {
    let id = UUID()
    let text: String
    let isMyMessage: Bool
}
