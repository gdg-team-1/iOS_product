//
//  HomeViewModel.swift
//  GDG_Alibi
//
//  Created by chungeunji on 2021/07/05.
//

import UIKit

protocol HomeViewRequestDelegate {
    func request(didSuccessRequest list: [RequestInfo])
    func request(didFailRequest message: String)
}

final class HomeViewModel {
    
    public var list: [RequestInfo] = []

    private var delegate: HomeViewRequestDelegate?

    private var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = DateUtil.server
        return formatter
    }()

    init(delegate: HomeViewRequestDelegate) {
        self.delegate = delegate
    }

    func requestList(_ date: Date, _ isSelf: Bool = false) {
        list.removeAll()

        let username = isSelf ? BasicUserInfo.shared.user.id ?? "" : ""
        let dueDate = dateFormatter.string(from: date)
        let location = LocationManager.shared.locationString
        
        NetworkAdapter.request(target: TargetAPI.getMyList(user: username,
                                                           dueDate: dueDate,
                                                           location: location)) { response in
            do {
                let list = try JSONDecoder().decode([RequestInfo].self, from: response.data)
                self.list = list
                self.delegate?.request(didSuccessRequest: list)
            } catch {
                print("parse error:", error)
            }
        } error: { error in
            print("error:", error.localizedDescription)
        } failure: { failError in
            print("Fail Error:", failError.localizedDescription)
        }
    }
}
