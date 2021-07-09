//
//  FormModel.swift
//  GDG_Alibi
//
//  Created by chungeunji on 2021/07/07.
//

import Foundation

class FormModel: Codable {
    var id: Int?
    var dday: String?
    var location: String?
    var category: [String] = []
    var requestUser: String?
    var title: String = ""
}
