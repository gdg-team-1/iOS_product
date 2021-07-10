//
//  ChatModel.swift
//  GDG_Alibi
//
//  Created by Lee on 2021/07/10.
//

import Foundation
import Firebase

struct ChatModel {
    
    let userID: String
    let message: String?
    let photoURL: String?
    let date: Date
    
    
    init(userID: String, message: String? = nil, photoURL: String? = nil) {
        self.userID = userID
        self.message = message
        self.photoURL = photoURL
        self.date = Date()
    }
    
    init(snapshot: QueryDocumentSnapshot) {
        let data = snapshot.data()
        
        self.userID = data["userID"] as? String ?? ""
        self.message = data["message"] as? String
        self.photoURL = data["photoURL"] as? String
        let tempDate = data["date"] as? Timestamp ?? Timestamp()
        self.date = tempDate.dateValue()
    }
    
    func toDictionary() -> [String: Any] {
        ["userID": self.userID, "message": self.message, "photoURL": self.photoURL, "date": Timestamp()]
    }
}
