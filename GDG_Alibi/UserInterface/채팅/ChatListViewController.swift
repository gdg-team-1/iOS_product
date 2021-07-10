//
//  ChatListViewController.swift
//  GDG_Alibi
//
//  Created by Lee on 2021/07/07.
//

import UIKit

class ChatListViewController: UIViewController {
    
    private var viewModel: ChatListViewModel = ChatListViewModel()
    
    private var selectIndex: IndexPath?
    
    
    @IBOutlet weak var requestButton: UIButton!
    @IBOutlet weak var heipButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        
        self.viewModel.updateCallBack = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard
            let dest = segue.destination as? ChatViewController,
            let index = self.selectIndex
        else { return }
        
        let documentID = self.viewModel.chatListData[index.row].chatDocumentID
        dest.viewModel = ChatViewModel(documentID: documentID)
    }
    
    @IBAction func repuestDidTap(_ sender: UIButton) {
        
        
    }
    
    @IBAction func heipDidTap(_ sender: UIButton) {
        
        
    }
    
    @IBAction func helpLongTouch(_ sender: UILongPressGestureRecognizer) {
        let alertVC = UIAlertController(title: "임시", message: "임시 유저 아이디", preferredStyle: .actionSheet)
        
        ["user1", "user2", "user3", "user4", "user5"].forEach { user in
            let action = UIAlertAction(title: user, style: .default) { _ in
                UserDefaults.standard.setValue(user, forKey: "userID")
            }
            alertVC.addAction(action)
        }
        
        let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        alertVC.addAction(cancel)
        
        self.present(alertVC, animated: true)
    }
}



// MARK: - UITableViewDataSource

extension ChatListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.chatListData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatListTableViewCell", for: indexPath) as! ChatListTableViewCell
        
        cell.bind(data: self.viewModel.chatListData[indexPath.row])
        
        return cell
    }
}



// MARK: - UITableViewDelegate

extension ChatListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectIndex = indexPath
        self.performSegue(withIdentifier: "chat", sender: nil)
    }
}
