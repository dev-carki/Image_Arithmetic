//
//  ChatBotView.swift
//  Image_Arithmetic
//
//  Created by Carki on 9/6/25.
//

import SwiftUI

struct ChatBotView: View {
    @StateObject private var viewModel = ChatBotViewModel()
    
    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 10) {
                        ForEach(viewModel.chatList) { message in
                            HStack {
                                if message.isMyMessage {
                                    Spacer()
                                    Text(message.text)
                                        .padding(10)
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .cornerRadius(12)
                                } else {
                                    Text(message.text)
                                        .padding(10)
                                        .background(Color.gray.opacity(0.2))
                                        .foregroundColor(.black)
                                        .cornerRadius(12)
                                    Spacer()
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .onChange(of: viewModel.chatList.count) { _ in
                    if let lastId = viewModel.chatList.last?.id {
                        withAnimation {
                            proxy.scrollTo(lastId, anchor: .bottom)
                        }
                    }
                }
            }
            
            // 입력창
            HStack {
                TextField("메시지를 입력하세요...", text: $viewModel.myChatText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: viewModel.sendMessage) {
                    Text("전송")
                        .padding(.horizontal, 8)
                        .padding(.vertical, 6)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding()
        }
    }
}

#Preview {
    ChatBotView()
}
