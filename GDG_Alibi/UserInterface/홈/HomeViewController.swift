//
//  HomeViewController.swift
//  GDG_Alibi
//
//  Created by chungeunji on 2021/07/05.
//

import UIKit
import JTAppleCalendar

class HomeViewController: UIViewController {

    lazy var viewModel: HomeViewModel = {
        return HomeViewModel()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension HomeViewController: JTACMonthViewDataSource {
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        let startDate = formatter.date(from: "2021 01 01")!
        let endDate = Date()
        return ConfigurationParameters(startDate: startDate, endDate: endDate)
    }
}

extension HomeViewController: JTACMonthViewDelegate {
    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        configureCell(view: cell, cellState: cellState)
    }

    func configureCell(view: JTACDayCell?, cellState: CellState) {
        guard let cell = view as? DateCollectionViewCell  else { return }
        cell.dateLabel.text = cellState.text
        cell.isHidden = !(cellState.dateBelongsTo == .thisMonth)
    }

    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: DateCollectionViewCell.id, for: indexPath) as! DateCollectionViewCell
        self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        return cell
    }
}
