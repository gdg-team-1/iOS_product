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

    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = DateUtil.receive
        return formatter
    }()

    var touchButton: (() -> Void)?

    var model: RequestInfo? {
        didSet {
            guard let model = model else { return }

            if let url = URL(string: model.profileUrl ?? "") {
                profileImageview.sd_setImage(with: url, completed: nil)
            } else {
                profileImageview.image = UIImage(named: "profilePlaceholder")
            }

            categoryLabel.text = model.category.first
            usernameLabel.text = model.requestUser
            timeLabel.text = calculateDateInterval(model.dday)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        profileImageview.layer.cornerRadius = profileImageview.bounds.width/2
        helpButton.layer.cornerRadius = 4
    }

    private func calculateDateInterval(_ dday: String?) -> String? {
        guard let dday = dday, let dueDate = dateFormatter.date(from: dday) else { return nil }
        let today = Date()
        let calendar = Calendar.current
        let unit: Set<Calendar.Component> = [.day, .hour, .minute]
        let components = calendar.dateComponents(unit, from: today, to: dueDate)

        var result: String = ""
        if let day = components.day, day > 0 {
            result += "\(day)일 내 필요"
            return result
        }
        if let hour = components.hour, hour > 0 { result += "\(hour)시간" }
        if let minute = components.minute, minute > 0 { result += "\(minute)분 " }
        if !result.isEmpty { result += "내 필요" }
        return result
    }

    @IBAction func touchButton(_ sender: Any) {
        touchButton?()
    }
}
