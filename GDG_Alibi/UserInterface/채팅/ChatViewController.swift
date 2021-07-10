//
//  ChatViewController.swift
//  GDG_Alibi
//
//  Created by Lee on 2021/07/07.
//

import UIKit

class ChatViewController: UIViewController {
    
    var viewModel: ChatViewModel!
    
    private let imagePickerController = UIImagePickerController()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textFieldView: UIView!
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var bottomViewConstraint: NSLayoutConstraint!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setKeyboardNotification()
        
        self.imagePickerController.allowsEditing = true
        self.imagePickerController.delegate = self
        
        self.textFieldView.layer.cornerRadius = 22
        
        self.tableView.register(ChatMyMessageTableViewCell.self, forCellReuseIdentifier: ChatMyMessageTableViewCell.identifier)
        self.tableView.register(ChatMyPhotoTableViewCell.self, forCellReuseIdentifier: ChatMyPhotoTableViewCell.identifier)
        self.tableView.register(ChatOtherMessageTableViewCell.self, forCellReuseIdentifier: ChatOtherMessageTableViewCell.identifier)
        self.tableView.register(ChatOtherPhotoTableViewCell.self, forCellReuseIdentifier: ChatOtherPhotoTableViewCell.identifier)
        
        self.viewModel.updateCallBack = { [weak self] in
            self?.tableView.reloadData()
            self?.tableViewBottomScroll()
        }
    }
    
    
    private func tableViewBottomScroll() {
        guard !self.viewModel.chatData.isEmpty else { return }
        let indexPath = IndexPath(row: self.viewModel.chatData.count - 1, section: 0)
        self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    private func addChat() {
        guard
            let userID = UserDefaults.standard.string(forKey: "userID"),
            let message = self.textField.text,
            !message.isEmpty
        else { return }
        
        let chat = ChatModel(userID: userID, message: message)
        self.viewModel.addMessage(chat: chat)
        
        self.textField.text = nil
    }
    
    
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func albumDidTap(_ sender: UIButton) {
        self.imagePickerController.sourceType = .photoLibrary
        self.imagePickerController.modalPresentationStyle = .fullScreen
        self.present(self.imagePickerController, animated: true)
    }
    
    @IBAction func sendDidTap(_ sender: UIButton) {
        self.addChat()
    }
}


extension ChatViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.addChat()
        return true
    }
}



// MARK: - UITableViewDataSource

extension ChatViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.chatData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userID = UserDefaults.standard.string(forKey: "userID")!
        let chat = self.viewModel.chatData[indexPath.row]
        
        let cell: ChatMessageTableViewCell
        switch userID == chat.userID {
        case true:
            switch chat.photoURL {
            case .some:
                cell = tableView.dequeueReusableCell(withIdentifier: ChatMyPhotoTableViewCell.identifier, for: indexPath) as! ChatMyPhotoTableViewCell
            case .none:
                cell = tableView.dequeueReusableCell(withIdentifier: ChatMyMessageTableViewCell.identifier, for: indexPath) as! ChatMyMessageTableViewCell
            }
            
        case false:
            switch chat.photoURL {
            case .some:
                cell = tableView.dequeueReusableCell(withIdentifier: ChatOtherPhotoTableViewCell.identifier, for: indexPath) as! ChatOtherPhotoTableViewCell
            case .none:
                cell = tableView.dequeueReusableCell(withIdentifier: ChatOtherMessageTableViewCell.identifier, for: indexPath) as! ChatOtherMessageTableViewCell
            }
            
        }
        
        cell.bind(chat: chat)
        
        return cell
    }
}



// MARK: - UITableViewDelegate

extension ChatViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Chat", bundle: nil)
        
        guard
            let photoURL = self.viewModel.chatData[indexPath.row].photoURL,
            let photo = FirebaseUtil.photos[photoURL],
            let vcChatPhoto = storyboard.instantiateViewController(withIdentifier: "ChatPhotoViewController") as? ChatPhotoViewController
        else { return }
        
        vcChatPhoto.photo = photo
        vcChatPhoto.modalPresentationStyle = .fullScreen
        self.present(vcChatPhoto, animated: true)
    }
}



// MARK: - Notification

extension ChatViewController {
    
    private func setKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardNotificationAction(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardNotificationAction(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardNotificationAction(_ notification: Notification) {
        guard
            let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
            let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt,
            let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        else { return }
        let height = keyboardFrame.cgRectValue.height - view.safeAreaInsets.bottom
        
        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: UIView.AnimationOptions(rawValue: curve),
            animations: { [weak self] in
                switch notification.name {
                case UIResponder.keyboardWillShowNotification:
                    self?.bottomViewConstraint?.constant = height
                    
                case UIResponder.keyboardWillHideNotification:
                    self?.bottomViewConstraint?.constant = 0
                    
                default:
                    break
                }
                self?.view.layoutIfNeeded()
            })
        
        self.tableViewBottomScroll()
    }
}



// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true)
        
        guard let originalImage = info[.originalImage] as? UIImage else {return}
        let editedImage = info[.editedImage] as? UIImage
        let selectedImage = editedImage ?? originalImage
        
        self.view.isUserInteractionEnabled = false
        let userID = UserDefaults.standard.string(forKey: "userID")!
        FirebaseUtil.imageUpload(image: selectedImage) { [weak self] result in
            guard let self = self, let photoURL = result else { return }
            self.view.isUserInteractionEnabled = true
            
            let chat = ChatModel(userID: userID, photoURL: photoURL)
            self.viewModel.addMessage(chat: chat)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
