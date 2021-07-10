//
//  ProfileViewController.swift
//  GDG_Alibi
//
//  Created by chungeunji on 2021/07/10.
//

import UIKit

final class ProfileViewController: UIViewController {

    static let id = "ProfileViewController"

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var registImageButton: UIButton!
    @IBOutlet weak var nameContainerView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var backButton: UIBarButtonItem!

    var isInitProcess: Bool = false

    let disable: UIColor = #colorLiteral(red: 0.8666666667, green: 0.8666666667, blue: 0.8666666667, alpha: 1)
    let enable: UIColor = #colorLiteral(red: 0.1529411765, green: 0.231372549, blue: 0.2823529412, alpha: 1)

    lazy var tapRecognizer: UITapGestureRecognizer = {
        return UITapGestureRecognizer(target: self, action: #selector(handleTap))
    }()

    lazy var viewModel: ProfileViewModel = {
        return ProfileViewModel()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        initViewModel()
    }

    private func initView() {
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        registImageButton.layer.cornerRadius = registImageButton.frame.size.width / 2
        registImageButton.layer.borderColor = UIColor.white.cgColor
        registImageButton.layer.borderWidth = 5

        nameContainerView.layer.cornerRadius = 4
        nameContainerView.layer.borderColor = disable.cgColor
        nameContainerView.layer.borderWidth = 1

        nameTextField.delegate = self

        navigationItem.leftBarButtonItem = isInitProcess ? backButton : nil
        navigationItem.rightBarButtonItem = isInitProcess ? doneButton : nil

        self.view.addGestureRecognizer(tapRecognizer)
    }

    private func initViewModel() {
        if isInitProcess { return }

        // TODO: 유저정보 셋팅
    }

    private func barButtonValidation() {
        navigationItem.rightBarButtonItem = nameTextField.text?.isEmpty ?? true ? nil : doneButton
    }

    @IBAction func touchRegistImage(_ sender: Any) {
        touchFeedback()
        // TODO: - barbutton validation 추가
    }

    @IBAction func touchBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func touchDone(_ sender: Any) {
        BasicUserInfo.shared.saveUserInfo()

        if isInitProcess {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            appDelegate.showHome()
        }

        navigationItem.rightBarButtonItem = nil
        nameTextField.resignFirstResponder()
    }

    @objc func handleTap() {
        nameTextField.resignFirstResponder()
    }
}

extension ProfileViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        nameContainerView.layer.borderColor = enable.cgColor
        nameTextField.text = nil
        navigationItem.rightBarButtonItem = doneButton
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard !(textField.text?.isEmpty ?? true) else { return false }
        nameContainerView.layer.borderColor = disable.cgColor
        nameTextField.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        nameContainerView.layer.borderColor = disable.cgColor
        barButtonValidation()
    }
}
