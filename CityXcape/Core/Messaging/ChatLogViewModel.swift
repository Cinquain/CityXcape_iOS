//
//  ChatLogViewModel.swift
//  CityXcape
//
//  Created by James Allan on 8/9/22.
//

import SwiftUI
import Firebase


class ChatLogViewModel: ObservableObject {


    @Published var message: String = ""
    @Published var errorMessage: String = ""
    @Published var messages: [Message] = []
    
    func sendMessage(toId: String) {
        DataService.instance.sendMessage(toId: toId, content: message) { [weak self] result in
            guard let self = self else {return}
            switch result {
                case .success(let success):
                    print("Successfully sent message", success)
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func fetchMessages(userId: String) {
        
        DataService.instance.getMessagesForUser(userID: userId) { [weak self] result in
            guard let self = self else {return}
            switch result {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                case .success(let returnedMessages):
                    self.messages = returnedMessages
            }
        }
        
    }
    
    
}
