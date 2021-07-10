//
//  UserModel.swift
//  GDG_Alibi
//
//  Created by chungeunji on 2021/07/07.
//

import UIKit

class UserModel: Codable {
    var id: String
    var nickname: String?
    var profileUrl: String?

    init() {
        id = UUID().uuidString
    }
}
