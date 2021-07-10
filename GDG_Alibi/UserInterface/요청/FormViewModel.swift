//
//  FormViewModel.swift
//  GDG_Alibi
//
//  Created by chungeunji on 2021/07/09.
//

import Foundation

final class FormViewModel {

    var model = FormModel()

    var doneSubmitForm: (() -> Void)?

    func submitForm() {
        model.location = LocationManager.shared.locationString
        model.requestUser = BasicUserInfo.shared.user.id
        NetworkAdapter.request(target: TargetAPI.submitAlibi(form: model)) { _ in
            self.doneSubmitForm?()
        } error: { error in
            print("error:", error)
        } failure: { failError in
            print("fail error:", failError)
        }
    }
}
