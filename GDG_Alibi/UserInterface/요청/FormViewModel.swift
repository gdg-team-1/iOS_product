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
        model.id = 1
        model.location = "서울특별시 종로구 혜화동"
        model.requestUser = "홍길동"
        model.title = ""

        NetworkAdapter.request(target: TargetAPI.submitAlibi(form: model)) { _ in
            self.doneSubmitForm?()
        } error: { error in
            print("error:", error)
        } failure: { failError in
            print("fail error:", failError)
        }
    }
}
