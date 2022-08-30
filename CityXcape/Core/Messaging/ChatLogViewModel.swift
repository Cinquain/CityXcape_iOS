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
    @Published var count: Int = 0
    
    init() {

    }
    
    func sendMessage(user: User) {
        DataService.instance.sendMessage(user: user, content: message) { [weak self] result in
            guard let self = self else {return}
            switch result {
                case .success(let message):
                    print("Successfully sent message")
                    self.messages.append(message)
                    self.message = ""
                    self.count += 1
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
                    self.count += 1
            }
        }
        
    }
    
    
    
    func deleteRecentMessage(userId: String) {
        DataService.instance.deleteRecentMessages(user: userId)
    }
    
    
}
