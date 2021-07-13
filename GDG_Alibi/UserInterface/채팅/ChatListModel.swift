//
//  ChatListModel.swift
//  GDG_Alibi
//
//  Created by Lee on 2021/07/07.
//

import Foundation
import Firebase

struct ChatListModel {
    
    let chatDocumentID: String
    let requestUser: String
    let helpUser: String
    let category: String
    let date: Date
    let lastMessage: String?
    
    
    
    init(snapshot: QueryDocumentSnapshot) {
        let data = snapshot.data()
        
        self.chatDocumentID = snapshot.documentID
        self.requestUser = data["requestUser"] as? String ?? ""
        self.helpUser = data["helpUser"] as? String ?? ""
        self.category = data["category"] as? String ?? ""
        let tempDate = data["date"] as? Timestamp ?? Timestamp()
        self.date = tempDate.dateValue()
        self.lastMessage = data["lastMessage"] as? String
    }
}
