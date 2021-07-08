//
//  DateCollectionViewCell.swift
//  GDG_Alibi
//
//  Created by chungeunji on 2021/07/06.
//

import UIKit
import JTAppleCalendar

final class DateCollectionViewCell: JTACDayCell {

    static let id = "DateCollectionViewCell"

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var selectView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()

        selectView.layer.cornerRadius = selectView.bounds.width/2
    }

    func updateSelection(_ isSelected: Bool) {
        selectView.isHidden = !isSelected
        dateLabel.textColor = isSelected ? .white : #colorLiteral(red: 0.1529411765, green: 0.231372549, blue: 0.2823529412, alpha: 1)
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        selectView.isHidden = true
        dateLabel.textColor = #colorLiteral(red: 0.1529411765, green: 0.231372549, blue: 0.2823529412, alpha: 1)
    }
}
