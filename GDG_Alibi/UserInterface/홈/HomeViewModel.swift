//
//  HomeViewModel.swift
//  GDG_Alibi
//
//  Created by chungeunji on 2021/07/05.
//

import Foundation

struct RequestInfo: Identifiable {
    var id: UUID = UUID()
    var date: Date
    var category: String
    var username: String
    var dueDate: String
}

protocol HomeViewRequestDelegate {
    func request(didSuccessRequest list: [RequestInfo])
    func request(didFailRequest message: String)
}

final class HomeViewModel {

    var list1 = [RequestInfo(date: Date(), category: "친구 사진만 필요", username: "푸키포", dueDate: "푸키포"),
    RequestInfo(date: Date(), category: "나와 같이 찍기", username: "아이린", dueDate: "17분 내 필요"),
    RequestInfo(date: Date(), category: "나와 같이 찍기", username: "김하나", dueDate: "2시간 32분 내 필요"),
    RequestInfo(date: Date(), category: "친구 사진만 필요", username: "푸키포", dueDate: "푸키포"),
    RequestInfo(date: Date(), category: "나와 같이 찍기", username: "아이린", dueDate: "17분 내 필요"),
    RequestInfo(date: Date(), category: "나와 같이 찍기", username: "김하나", dueDate: "2시간 32분 내 필요"),
    RequestInfo(date: Date(), category: "친구 사진만 필요", username: "푸키포", dueDate: "푸키포"),
    RequestInfo(date: Date(), category: "나와 같이 찍기", username: "아이린", dueDate: "17분 내 필요"),
    RequestInfo(date: Date(), category: "나와 같이 찍기", username: "김하나", dueDate: "2시간 32분 내 필요")]
    var list2: [RequestInfo] = []

    var delegate: HomeViewRequestDelegate?

    init(delegate: HomeViewRequestDelegate) {
        self.delegate = delegate
    }

    func requestList() {
        self.delegate?.request(didSuccessRequest: list1)
    }
}
