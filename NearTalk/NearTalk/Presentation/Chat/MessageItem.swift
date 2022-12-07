//
//  MessageItem.swift
//  NearTalk
//
//  Created by dong eun shin on 2022/12/07.
//

import Foundation

struct MessageItem: Hashable {
    var id: String
    var userName: String
    var message: String?
    var type: MyMessageType
    var imagePath: String?
    var createdDate: Date
    
    init(chatMessage: ChatMessage, myID: String, userProfile: UserProfile?) {
        self.id = chatMessage.uuid ?? UUID().uuidString
        self.userName = userProfile?.username  ?? "알수없음"
        self.message = chatMessage.text
        self.type = chatMessage.senderID == myID ? MyMessageType.send : MyMessageType.receive
        self.imagePath = userProfile?.profileImagePath ?? "이미지없음"
        self.createdDate = chatMessage.createdAt ?? Date()
    }
}

enum MyMessageType: String {
    case send
    case receive
}