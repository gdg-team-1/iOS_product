//
//  ChatListViewController.swift
//  GDG_Alibi
//
//  Created by Lee on 2021/07/07.
//

import UIKit

class ChatListViewController: UIViewController {
    
    private lazy var viewModel: ChatListViewModel = {
        ChatListViewModel()
    }()
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    
}



// MARK: - UITableViewDataSource

extension ChatListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.tempData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatListTableViewCell", for: indexPath) as! ChatListTableViewCell
        
        cell.bind(data: self.viewModel.tempData[indexPath.row])
        
        return cell
    }
}



// MARK: - UITableViewDelegate

extension ChatListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
