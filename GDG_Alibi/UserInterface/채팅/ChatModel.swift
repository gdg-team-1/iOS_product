//
//  ChatModel.swift
//  GDG_Alibi
//
//  Created by Lee on 2021/07/10.
//

import Foundation
import Firebase

struct MessageModel {
    
    let userID: String
    let message: String?
    let imageURL: String?
    let date: Date
    
    
    
    init(snapshot: QueryDocumentSnapshot) {
        let data = snapshot.data()
        
        self.userID = data["userID"] as? String ?? ""
        self.message = data["message"] as? String
        self.imageURL = data["imageURL"] as? String
        let tempDate = data["date"] as? Timestamp ?? Timestamp()
        self.date = tempDate.dateValue()
    }
    
    func toDictionary() -> [String: Any] {
        ["userID": self.userID, "message": self.message, "date": Timestamp()]
    }
}
