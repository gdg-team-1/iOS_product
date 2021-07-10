//
//  SelectNeighborViewController.swift
//  GDG_Alibi
//
//  Created by chungeunji on 2021/07/10.
//

import UIKit

class SelectNeighborViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var closeBarButton: UIBarButtonItem!
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var selectionView: UIView!

    var neighborhoods: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
    }

    private func initView() {
        self.title = LocationManager.shared.tempLocation?.district

        navigationItem.rightBarButtonItem = LocationManager.shared.myCity.isEmpty ? nil : closeBarButton
        
        tableView.register(UINib(nibName: LocationTableViewCell.id, bundle: nil), forCellReuseIdentifier: LocationTableViewCell.id)
        tableView.tableFooterView = UIView(frame: .zero)

        selectButton.setBackgroundColor(#colorLiteral(red: 0.1725490196, green: 0.7803921569, blue: 0.5058823529, alpha: 1), for: .normal)
        selectButton.setBackgroundColor(#colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1), for: .disabled)
        selectButton.isEnabled = false
        selectButton.layer.cornerRadius = 4

        selectionView.layer.shadowColor = UIColor.black.cgColor
        selectionView.layer.shadowOpacity = 0.1
        selectionView.layer.shadowOffset = .zero
        selectionView.layer.shadowRadius = 4
    }

    private func setNeighbor(_ selected: String = "") {
        LocationManager.shared.set(neighbor: selected)
        selectButton.isEnabled = !(LocationManager.shared.tempLocation?.neighbor.isEmpty ?? true)
    }

    @IBAction func didTouchDismiss(_ sender: Any) {
        touchFeedback()
        navigationController?.popViewController(animated: true)
    }

    @IBAction func dismiss(_ sender: Any) {
        touchFeedback()
        dismiss(animated: true, completion: nil)
    }

    @IBAction func touchSelect(_ sender: Any) {
        touchFeedback()

        LocationManager.shared.saveLocationInfo()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.showHome()
    }
}

extension SelectNeighborViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        neighborhoods.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LocationTableViewCell.id, for: indexPath) as! LocationTableViewCell
        cell.model = neighborhoods[indexPath.row]
        return cell
    }
}

extension SelectNeighborViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        touchFeedback()

        tableView.visibleCells.forEach({ $0.accessoryType = .none })
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark

        setNeighbor(neighborhoods[indexPath.row])
    }
}

