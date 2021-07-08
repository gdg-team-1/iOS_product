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

    let formatter = DateFormatter()

    lazy var viewModel: HomeViewModel = {
        return HomeViewModel(delegate: self)
    }()

    private lazy var emptyView: EmptyView = {
        let emptyView = EmptyView(frame: tableView.bounds)
        emptyView.isHidden = true
        return emptyView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        initViewModel()
    }

    private func initView() {
        let locationView = LocationBarView()
        locationView.touchLocationItem = {
            // TODO: - 리스트 불러오기
        }
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: locationView)
        let checkView = CheckBoxView()
        checkView.touchFilter = { [weak self] isSelected in
            // TODO: - 리스트 필터링 하기
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: checkView)

        navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.layoutIfNeeded()

        tableView.backgroundView = emptyView
        tableView.estimatedRowHeight = 105
        tableView.register(UINib(nibName: RequestTableViewCell.id, bundle: nil), forCellReuseIdentifier: RequestTableViewCell.id)
        monthView.register(UINib(nibName: MonthCollectionReusableView.id, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MonthCollectionReusableView.id)
    }

    private func initViewModel() {
    }

    @IBAction func moveMonth(_ sender: UIButton) {

    }
}

extension HomeViewController: HomeViewRequestDelegate {
    func request(didSuccessRequest list: [RequestInfo]) {
        emptyView.isHidden = list.count > 0
        tableView.reloadData()
    }

    func request(didFailRequest message: String) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
}

extension HomeViewController: JTACMonthViewDataSource {
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        let startDate = formatter.date(from: formatter.string(for: Date())!)!
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

    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        guard let cell = cell as? DateCollectionViewCell else { return }
        cell.updateSelection(true)
        // TODO: - tableview list 업데이트
        viewModel.requestList()
    }

    func calendar(_ calendar: JTACMonthView, didDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        guard let cell = cell as? DateCollectionViewCell else { return }
        cell.updateSelection(false)
    }

    func calendar(_ calendar: JTACMonthView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTACMonthReusableView {
        formatter.dateFormat = "M월"
        let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: MonthCollectionReusableView.id, for: indexPath) as! MonthCollectionReusableView
        header.monthLabel.text = formatter.string(from: range.start)
        return header
    }

    func calendarSizeForMonths(_ calendar: JTACMonthView?) -> MonthSize? {
        MonthSize(defaultSize: 99)
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.list1.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RequestTableViewCell.id, for: indexPath) as? RequestTableViewCell else { return UITableViewCell() }
        cell.touchButton = {

        }
        cell.model = viewModel.list1[indexPath.row]
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {

}

