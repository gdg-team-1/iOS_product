//
//  RequestTableViewCell.swift
//  GDG_Alibi
//
//  Created by chungeunji on 2021/07/08.
//

import UIKit
import SDWebImage

final class RequestTableViewCell: UITableViewCell {

    static let id = "RequestTableViewCell"

    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var profileImageview: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var helpButton: UIButton!

    var touchButton: (() -> Void)?

    var model: RequestInfo? {
        didSet {
//            profileImageview.image = model?.profile
            categoryLabel.text = model?.category.first
            usernameLabel.text = model?.requestUser
            timeLabel.text = model?.dday
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        profileImageview.layer.cornerRadius = profileImageview.bounds.width/2
        helpButton.layer.cornerRadius = 4
    }

    @IBAction func touchButton(_ sender: Any) {
        touchButton?()
    }
}
