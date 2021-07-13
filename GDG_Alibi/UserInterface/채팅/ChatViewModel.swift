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
    var chatData: [ChatModel] = [ChatModel]() {
        didSet {
            self.updateCallBack?()
        }
    }
    
    var updateCallBack: (() -> Void)?
    
    
    
    init(documentID: String) {
        self.documentID = documentID
        
        self.addListener()
    }
    
    deinit {
        self.listener?.remove()
    }
    
    
    
    // 채팅 리스너
    private func addListener() {
        self.listener = firestore
            .collection("chatList")
            .document(self.documentID)
            .collection("message")
            .addSnapshotListener { [weak self] (snapshot, error) in
                
                print("\n---------------------- [ ChatViewModel addListener ] ----------------------")
                
                if let error = error {
                    print("\n---------------------- [ \(error.localizedDescription) ] ----------------------")
                    
                } else {
                    guard let self = self, let documents = snapshot?.documents else { return }
                    
                    var tempData = [ChatModel]()
                    
                    for document in documents {
                        let message = ChatModel(snapshot: document)
                        
                        tempData.append(message)
                    }
                    
                    tempData.sort { $0.date < $1.date }
                    self.chatData = tempData
                }
            }
    }
    
    
    
    // 메시지 추가
    func addMessage(chat: ChatModel) {
        
        print("\n---------------------- [ ChatViewModel addMessage ] ----------------------")
        
        self.firestore
            .collection("chatList")
            .document(self.documentID)
            .collection("message")
            .addDocument(data: chat.toDictionary())
        
        self.firestore
            .collection("chatList")
            .document(self.documentID)
            .updateData(["lastMessage": chat.message])
    }
}
