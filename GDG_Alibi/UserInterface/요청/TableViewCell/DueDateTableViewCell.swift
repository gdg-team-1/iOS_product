//
//  DueDateTableViewCell.swift
//  GDG_Alibi
//
//  Created by chungeunji on 2021/07/08.
//

import UIKit

final class DueDateTableViewCell: UITableViewCell {

    static let id = "DueDateTableViewCell"

    @IBOutlet weak var dateLabel: UILabel!

    @IBOutlet var chevronImageViews: [UIImageView]!
    @IBOutlet var boxViews: [UIView]!

    @IBOutlet weak var pickerHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var pickerView: UIDatePicker!

    var touchDateBox: (() -> Void)?

    var model: FormModel?

    override func awakeFromNib() {
        super.awakeFromNib()

        initView()
    }

    private func initView() {
        boxViews.forEach({
            $0.layer.cornerRadius = 17
            $0.layer.borderColor = #colorLiteral(red: 0.1529411765, green: 0.231372549, blue: 0.2823529412, alpha: 1)
            $0.layer.borderWidth = 1
        })

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier:"ko_KR")

        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        model?.dday = dateFormatter.string(from: Date())

        dateFormatter.dateFormat = "MM월 dd일 E요일 a hh시 mm분"
        dateLabel.text = dateFormatter.string(from: Date())
    }

    @IBAction func selectBox(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        let isSelected = sender.isSelected
        pickerView.isHidden = !sender.isSelected
        pickerHeightConstraint.constant = isSelected ? 216 : 0
        chevronImageViews[sender.tag].transform = isSelected ? CGAffineTransform(rotationAngle: .pi) : .identity

        UIView.animate(withDuration: 0.1) {
            self.layoutIfNeeded()
        } completion: { _ in
            self.touchDateBox?()
        }
    }

    @IBAction func selectDate(_ sender: UIDatePicker) {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier:"ko_KR")

        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let selectedDate: String = dateFormatter.string(from: sender.date)
        model?.dday = selectedDate

        dateFormatter.dateFormat = "MM월 dd일 E요일 a hh시 mm분"
        let today = dateFormatter.string(from: sender.date)
        dateLabel.text = today
    }
}
