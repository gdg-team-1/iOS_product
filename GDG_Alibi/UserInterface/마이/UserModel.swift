//
//  UserModel.swift
//  GDG_Alibi
//
//  Created by chungeunji on 2021/07/07.
//

import UIKit

struct UserModel: Identifiable {
    var id: UUID = UUID()
    var username: String
    var profile: UIImage
}
