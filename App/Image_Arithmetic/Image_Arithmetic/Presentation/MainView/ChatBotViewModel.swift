//
//  ChatBotViewModel.swift
//  Image_Arithmetic
//
//  Created by Carki on 9/6/25.
//

import Foundation

final class ChatBotViewModel: ObservableObject {
    @Published var myChatText: String = ""
    @Published var chatList: [Message] = []
    
    func sendMessage() {
        let text = Message(text: myChatText, isMyMessage: true)
        chatList.append(text)
        myChatText = ""
    }
}
