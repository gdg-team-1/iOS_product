//
//  SelectCityViewController.swift
//  GDG_Alibi
//
//  Created by chungeunji on 2021/07/09.
//

import UIKit

extension Notification.Name {
    static let didDismissViewController = NSNotification.Name(rawValue: "didDismissViewController")
    static let didCompleteChoosingLocation = NSNotification.Name(rawValue: "didCompleteChoosingLocation")
}

final class SelectCityViewController: UIViewController, ViewInfo {

    static var id = "SelectCityViewController"

    var cities: [CityModel] = []

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var closeBarButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
    }

    private func initView() {
        tableView.register(UINib(nibName: LocationTableViewCell.id, bundle: nil), forCellReuseIdentifier: LocationTableViewCell.id)
        tableView.tableFooterView = UIView(frame: .zero)
        
        cities = LocationManager.shared.cities

        navigationItem.rightBarButtonItem = LocationManager.shared.myCity.isEmpty ? nil : closeBarButton
    }

    @IBAction func didTouchDismissButton(_ sender: Any) {
        touchFeedback()
        dismiss(animated: true, completion: nil)
    }
}

extension SelectCityViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LocationTableViewCell.id, for: indexPath) as! LocationTableViewCell
        cell.model = cities[indexPath.row]
        return cell
    }
}

extension SelectCityViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        touchFeedback()

        tableView.visibleCells.forEach({ $0.accessoryType = .none })
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark

        LocationManager.shared.set(city: cities[indexPath.row].cityName)

        if cities[indexPath.row].cityName == "세종특별자치시" {
            performSegue(withIdentifier: "showException", sender: cities[indexPath.row])
        } else {
            performSegue(withIdentifier: "showDistrict", sender: cities[indexPath.row])
        }
    }
}

extension SelectCityViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showException":
            guard let destination = segue.destination as? SelectNeighborViewController,
                  let selectedModel = sender as? CityModel else { return }
            destination.neighborhoods = selectedModel.districts.first?.neighborhoods ?? []

        default:
            guard let destination = segue.destination as? SelectDistrictViewController,
                  let selectedModel = sender as? CityModel else { return }
            destination.districts = selectedModel.districts
        }
    }
}

extension UIViewController {
    func touchFeedback() {
        UISelectionFeedbackGenerator().selectionChanged()
    }
}

