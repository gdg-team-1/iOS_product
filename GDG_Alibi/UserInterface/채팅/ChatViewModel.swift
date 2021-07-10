//
//  ChatViewModel.swift
//  GDG_Alibi
//
//  Created by Lee on 2021/07/08.
//

import Foundation
import Firebase

class ChatViewModel {
    
    private var listener: ListenerRegistration?
    private let firestore = Firestore.firestore()
    
    
    private let documentID: String
    var chatData: [MessageModel] = [MessageModel]() {
        didSet {
            self.updateCallBack?()
        }
    }
    
    var updateCallBack: (() -> Void)?
    
    
    
    init(documentID: String) {
        self.documentID = documentID
        
        self.addListener()
    }
    
    private func addListener() {
      listener = firestore
        .collection("chatList")
        .document(self.documentID)
        .collection("message")
        .addSnapshotListener { [weak self] (snapshot, error) in
          
          print("\n---------------------- [ ChatViewModel addListener ] ----------------------")
          
          if let error = error {
            print("\n---------------------- [ \(error.localizedDescription) ] ----------------------")
            
            
          } else {
            guard let self = self, let documents = snapshot?.documents else { return }
            
            var tempData = [MessageModel]()
            
            for document in documents {
                let message = MessageModel(snapshot: document)
                
                tempData.append(message)
            }
            
            tempData.sort { $0.date < $1.date }
            self.chatData = tempData
          }
        }
    }
    
    
    
    func addMessage(message: MessageModel) {
        self.firestore
            .collection("chatList")
            .document(self.documentID)
            .collection("message")
            .addDocument(data: message.toDictionary())
    }
    
    
    
    func out() {
        self.listener?.remove()
    }
}
