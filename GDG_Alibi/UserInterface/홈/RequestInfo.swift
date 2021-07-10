//
//  HomeModel.swift
//  GDG_Alibi
//
//  Created by chungeunji on 2021/07/05.
//

import Foundation

struct RequestInfo: Identifiable, Decodable {
    var id: Int
    var category: [String]
    var dday: String?
    var location: String
    var requestUser: String?
}
