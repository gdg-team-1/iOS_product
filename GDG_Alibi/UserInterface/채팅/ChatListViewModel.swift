//
//  ChatListViewModel.swift
//  GDG_Alibi
//
//  Created by Lee on 2021/07/07.
//

import Foundation

class ChatListViewModel {
    
    let tempData: [ChatListModel] = {
        (0...20).map {
            ChatListModel(itemID: "",
                          chatID: "documentID",
                          users: [""],
                          title: String($0),
                          sub: "sub",
                          date: Date())
        }
    }()
    
    
}
