//
//  BasicUserInfo.swift
//  GDG_Alibi
//
//  Created by chungeunji on 2021/07/10.
//

import UIKit

typealias UserType = (id: UInt8, name: String, profile: UIImage?)

final class BasicUserInfo: Identifiable {

    static let shared = BasicUserInfo()

    typealias Dict = [String: Any?]

    struct Key {
        static let id = "id"
        static let name = "name"
        static let profile = "profile"
    }

    var userInfo: Dict? {
        if let info = UserDefaults.standard.dictionary(forKey: UserDefaultsKey.userInfo) {
            return info
        } else {
            return nil
        }
    }

    var userId: UInt8
    var username: String?
    var profileImage: UIImage?
    var profileUrl: String?

    init() {
        userId = UUID().uuid.0
    }

    public func set(username: String) {
        self.username = username
    }

    public func setProfile(image: UIImage) {
        self.profileImage = image
    }

    public func saveUserInfo() {
        let dict: Dict = [Key.id: userId,
                          Key.name: username,
                          Key.profile: profileImage]
        UserDefaults.standard.setValue(dict, forKey: UserDefaultsKey.userInfo)
    }
}
