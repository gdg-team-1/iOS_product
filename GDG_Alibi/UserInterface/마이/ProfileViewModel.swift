//
//  ProfileViewModel.swift
//  GDG_Alibi
//
//  Created by chungeunji on 2021/07/10.
//

import UIKit

protocol ProfileRegisterDelegate {
    func profileRegistDidSuccess()
    func profileRegistDidFail(_ message: String)
}

final class ProfileViewModel {

    var user = UserModel()
    var profileImage: UIImage?

    var delegate: ProfileRegisterDelegate?

    init(delegate: ProfileRegisterDelegate) {
        self.delegate = delegate
    }

    let dispatchQueue = DispatchQueue(label: "cloth info request", qos: .background, attributes: .concurrent)
    let dispatchGroup = DispatchGroup()

    func submitUser() {
        dispatchGroup.enter()
        dispatchQueue.async {
            self.registProfile(self.profileImage)
        }
        dispatchGroup.enter()
        dispatchQueue.async {
            self.registUser()
        }

        dispatchGroup.notify(queue: .main) {
            self.delegate?.profileRegistDidSuccess()
        }
    }

    func registProfile(_ image: UIImage?) {
        guard let image = image else { return }

        NetworkAdapter.request(target: TargetAPI.profileUpload(image: image)) { response in
            self.dispatchGroup.leave()
        } error: { error in
            self.dispatchGroup.leave()
            self.delegate?.profileRegistDidFail(error.localizedDescription)
        } failure: { failError in
            self.dispatchGroup.leave()
            self.delegate?.profileRegistDidFail(failError.localizedDescription)
        }
    }

    func registUser() {
        NetworkAdapter.request(target: TargetAPI.submitUser(user: user)) { response in
            self.dispatchGroup.leave()
        } error: { error in
            self.dispatchGroup.leave()
            self.delegate?.profileRegistDidFail(error.localizedDescription)
        } failure: { failError in
            self.dispatchGroup.leave()
            self.delegate?.profileRegistDidFail(failError.localizedDescription)
        }
    }

    func editUserInfo() {
        NetworkAdapter.request(target: TargetAPI.editUser(id: user.id, user: user)) { response in

        } error: { error in
            self.delegate?.profileRegistDidFail(error.localizedDescription)
        } failure: { failError in
            self.delegate?.profileRegistDidFail(failError.localizedDescription)
        }
    }
}
