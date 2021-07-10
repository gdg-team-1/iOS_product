//
//  BasicUserInfo.swift
//  GDG_Alibi
//
//  Created by chungeunji on 2021/07/10.
//

import UIKit

final class BasicUserInfo {

    static let shared = BasicUserInfo()

    var isFirstLaunch: Bool { return UserDefaults.standard.string(forKey: UserDefaultsKey.id) == nil }

    var user: UserModel = UserModel() {
        didSet {
            if let id = user.id, !id.isEmpty {
                setUserId(id)
            }
        }
    }
    var profileImage: UIImage?

    public func setProfile(image: UIImage) {
        self.profileImage = image
    }

    public func setUserId(_ id: String) {
        UserDefaults.standard.setValue(id, forKey: UserDefaultsKey.id)
    }

    public func getUserInfo(completion: @escaping ((String?) -> Void)) {
        guard let id = UserDefaults.standard.string(forKey: UserDefaultsKey.id) else { return }
        
        NetworkAdapter.request(target: TargetAPI.getUserInfo(id: id)) { response in
            do {
                let user = try JSONDecoder().decode(UserModel.self, from: response.data)
                self.user = user
                completion(.none)
            } catch {
                completion(error.localizedDescription)
            }
        } error: { error in
            completion(error.localizedDescription)
        } failure: { failError in
            completion(failError.localizedDescription)
        }
    }
}
