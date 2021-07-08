//
//  HomeViewController.swift
//  GDG_Alibi
//
//  Created by chungeunji on 2021/07/05.
//

import UIKit
import JTAppleCalendar

class HomeViewController: UIViewController {

    @IBOutlet weak var monthView: JTACMonthView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var monthLabel: UILabel!

    lazy var viewModel: HomeViewModel = {
        return HomeViewModel()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
    }

    private func initView() {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: Date())
        monthLabel.text = "\(month)월"

        tableView.estimatedRowHeight = 105
        tableView.register(UINib(nibName: RequestTableViewCell.id, bundle: nil), forCellReuseIdentifier: RequestTableViewCell.id)
    }

    @IBAction func moveMonth(_ sender: UIButton) {

    }
}

extension HomeViewController: JTACMonthViewDataSource {
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        let startDate = formatter.date(from: "2021 01 01")!
        let endDate = formatter.date(from: "2022 12 31")!
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

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RequestTableViewCell.id, for: indexPath) as? RequestTableViewCell else { return UITableViewCell() }
        cell.touchButton = {

        }
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {

}

