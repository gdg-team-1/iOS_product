//
//  SelectDistrictViewController.swift
//  GDG_Alibi
//
//  Created by chungeunji on 2021/07/10.
//

import UIKit

class SelectDistrictViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    // MARK: - Properties
    var districts: [DistrictModel] = []

    @IBOutlet weak var closeBarButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
    }

    private func initView() {
        self.title = LocationManager.shared.tempLocation?.city
        
        tableView.register(UINib(nibName: LocationTableViewCell.id, bundle: nil), forCellReuseIdentifier: LocationTableViewCell.id)
        tableView.tableFooterView = UIView(frame: .zero)

        navigationItem.rightBarButtonItem = LocationManager.shared.myDistrict.isEmpty ? nil : closeBarButton
    }

    // MARK: - IBActions
    @IBAction func didTouchDismiss(_ sender: Any) {
        touchFeedback()
        navigationController?.popViewController(animated: true)
    }

    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension SelectDistrictViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        districts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LocationTableViewCell.id, for: indexPath) as! LocationTableViewCell
        cell.model = districts[indexPath.row]
        return cell
    }
}

extension SelectDistrictViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        touchFeedback()

        tableView.visibleCells.forEach({ $0.accessoryType = .none })
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark

        LocationManager.shared.set(district: districts[indexPath.row].districtName)

        performSegue(withIdentifier: "showNeighbor", sender: districts[indexPath.row])
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? SelectNeighborViewController,
              let selectedDistrict = sender as? DistrictModel else { return }
        destination.neighborhoods = selectedDistrict.neighborhoods
    }
}

