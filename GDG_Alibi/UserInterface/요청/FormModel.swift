//
//  FormModel.swift
//  GDG_Alibi
//
//  Created by chungeunji on 2021/07/07.
//

import Foundation

class FormModel: Codable, Identifiable {
    private enum CodingKeys: String, CodingKey {
        case dueDate = "dday"
        case location
        case need
        case user = "requestUser"
        case title
    }

    var id: UUID?
    
    var dueDate: String
    var location: String
    var need: [String]
    var user: String
    var title: String
}
