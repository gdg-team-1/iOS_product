//
//  ChatListViewModel.swift
//  GDG_Alibi
//
//  Created by Lee on 2021/07/07.
//

import Foundation
import FirebaseFirestore

class ChatListViewModel {
    
    private var listener: ListenerRegistration?
    private let firestore = Firestore.firestore()
    
    var chatListData: [ChatListModel] = [ChatListModel]() {
        didSet {
            self.updateCallBack?()
        }
    }
    
    var updateCallBack: (() -> Void)?
    
    
    
    init() {
        self.getList()
    }
    
    deinit {
        self.listener?.remove()
    }
    
    
    
    func getList() {
        self.listener = firestore
            .collection("chatList")
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("\n---------------------- [ \(error.localizedDescription) ] ----------------------")
                    
                } else {
                    guard let docuemnts = snapshot?.documents else { return }
                    
                    var tempData = [ChatListModel]()
                    for document in docuemnts {
                        let chatList = ChatListModel(snapshot: document)
                        tempData.append(chatList)
                    }
                    self.chatListData = tempData
                }
            }
    }
}
