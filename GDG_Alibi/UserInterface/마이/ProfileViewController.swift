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

    lazy var imagePicker: UIImagePickerController = {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.allowsEditing = true
        return vc
    }()

    var isInitProcess: Bool = false

    let disable: UIColor = #colorLiteral(red: 0.8666666667, green: 0.8666666667, blue: 0.8666666667, alpha: 1)
    let enable: UIColor = #colorLiteral(red: 0.1529411765, green: 0.231372549, blue: 0.2823529412, alpha: 1)

    lazy var tapRecognizer: UITapGestureRecognizer = {
        return UITapGestureRecognizer(target: self, action: #selector(handleTap))
    }()

    lazy var viewModel: ProfileViewModel = {
        return ProfileViewModel(delegate: self)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
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

        imagePicker.delegate = self

        if !isInitProcess {
            profileImageView.image = BasicUserInfo.shared.profileImage
            nameTextField.text = viewModel.user?.id
        }
    }

    private func barButtonValidation() {
        navigationItem.rightBarButtonItem = nameTextField.text?.isEmpty ?? true ? nil : doneButton
    }

    @IBAction func touchRegistImage(_ sender: Any) {
        FirebaseUtil.addChat(requestUser: "업쓰", helpUser: "하하하", category: "사진사진") { error in
            switch error {
            case .some(let error):
                print("\n---------------------- [ \(error.localizedDescription) ] ----------------------")
                
            case .none:
                // 채팅 화면으로 고고
                break
            }
        }
//        touchFeedback()
//        present(imagePicker, animated: true, completion: nil)
    }

    @IBAction func touchBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @objc @IBAction func touchDone(_ sender: Any) {
        guard let name = nameTextField.text else { return }

        if isInitProcess {
            viewModel.user?.id = name
            viewModel.registUser()
        } else {
            viewModel.user?.id = name
            viewModel.editUserInfo()
        }

        BasicUserInfo.shared.setUserId(name)

        navigationItem.rightBarButtonItem = nil
        nameTextField.resignFirstResponder()
    }

    @objc func handleTap() {
        nameTextField.resignFirstResponder()
    }
}

extension ProfileViewController: ProfileRegisterDelegate {
    func profileRegistDidSuccess() {
        if isInitProcess {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            appDelegate.showHome()
        }
    }

    func profileRegistDidFail(_ message: String) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
}

extension ProfileViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        nameContainerView.layer.borderColor = enable.cgColor
        nameTextField.text = nil

        let done = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(touchDone(_:)))
        done.tintColor = enable
        navigationItem.rightBarButtonItem = done
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

extension ProfileViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let path = info[.imageURL] as? NSURL {
            if path.absoluteString?.hasSuffix("JPG") ?? false {
                viewModel.type = .JPG
            } else if path.absoluteString?.hasSuffix("PNG") ?? false {
                viewModel.type = .PNG
            } else {
                viewModel.type = .NONE
            }
        }

        if let image = info[.originalImage] as? UIImage {
            let resizeImage = resizeImage(image: image)
            BasicUserInfo.shared.profileImage = resizeImage
            viewModel.profileImage = resizeImage
            profileImageView.image = resizeImage
            viewModel.registProfile()
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }

    private func resizeImage(image: UIImage, newWidth: CGFloat = 200) -> UIImage? {
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
