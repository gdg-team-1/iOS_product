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
    let itemID: String
    let users: [String]
    let title: String
    let sub: String
    let date: Date
    
    
    
    init(snapshot: QueryDocumentSnapshot) {
        let data = snapshot.data()
        
        self.chatDocumentID = snapshot.documentID
        self.itemID = data["itemID"] as? String ?? ""
        self.users = data["users"] as? [String] ?? [String]()
        self.title = data["title"] as? String ?? ""
        self.sub = data["sub"] as? String ?? ""
        let tempDate = data["date"] as? Timestamp ?? Timestamp()
        self.date = tempDate.dateValue()
    }
}
