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

enum ImageType: String {
    case JPG, PNG, NONE

    var mime: String {
        switch self {
        case .JPG:      return "image/jpeg"
        case .PNG:      return "image/png"
        case .NONE:     return ""
        }
    }
}

final class ProfileViewModel {

    var user: UserModel? = BasicUserInfo.shared.user

    var profileImage: UIImage? = BasicUserInfo.shared.profileImage
    var type: ImageType = .JPG

    var delegate: ProfileRegisterDelegate?

    init(delegate: ProfileRegisterDelegate) {
        self.delegate = delegate
    }

    func registProfile() {
        guard let image = profileImage else { return }

        var compressedData: Data = Data()
        switch type {
        case .JPG:
            if let data = image.jpegData(compressionQuality: 1.0) {
                compressedData = data
            }
        case .PNG:
            if let data = image.pngData() {
                compressedData = data
            }
        case .NONE:
            self.delegate?.profileRegistDidFail("해당 파일은 올릴 수 없는 확장자입니다")
        }

        NetworkAdapter.request(target: TargetAPI.profileUpload(data: compressedData, mimeType: type.mime)) { response in
        } error: { error in
            self.delegate?.profileRegistDidFail(error.localizedDescription)
        } failure: { failError in
            self.delegate?.profileRegistDidFail(failError.localizedDescription)
        }
    }

    func registUser() {
        guard let user = user else { return }
        NetworkAdapter.request(target: TargetAPI.submitUser(user: user)) { response in
            self.delegate?.profileRegistDidSuccess()
        } error: { error in
            self.delegate?.profileRegistDidFail(error.localizedDescription)
        } failure: { failError in
            self.delegate?.profileRegistDidFail(failError.localizedDescription)
        }
    }

    func editUserInfo() {
        guard let user = user, let id = user.id else { return }
        NetworkAdapter.request(target: TargetAPI.editUser(id: id, user: user)) { response in
            self.delegate?.profileRegistDidSuccess()
        } error: { error in
            self.delegate?.profileRegistDidFail(error.localizedDescription)
        } failure: { failError in
            self.delegate?.profileRegistDidFail(failError.localizedDescription)
        }
    }
}
