//
//  MonthCollectionReusableView.swift
//  GDG_Alibi
//
//  Created by chungeunji on 2021/07/08.
//

import UIKit
import JTAppleCalendar

final class MonthCollectionReusableView: JTACMonthReusableView {

    static let id = "MonthCollectionReusableView"

    @IBOutlet weak var monthLabel: UILabel!

    var touchMoveButton: ((Int) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func touchMoveButton(_ sender: UIButton) {
        touchMoveButton?(sender.tag)
    }
}
