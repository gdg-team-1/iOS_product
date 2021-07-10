//
//  ChatPhotoViewController.swift
//  GDG_Alibi
//
//  Created by Lee on 2021/07/11.
//

import UIKit

class ChatPhotoViewController: UIViewController {
    
    var photo: UIImage?
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.photoImageView.image = self.photo
    }
    
    @IBAction func dismissDidTap(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}
