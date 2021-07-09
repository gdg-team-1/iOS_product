//
//  FormViewController.swift
//  GDG_Alibi
//
//  Created by chungeunji on 2021/07/08.
//

import UIKit

enum SectionType: Int, CaseIterable {
    case dueDate
    case category
}

final class FormViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var submitButton: UIButton!

    private lazy var viewModel: FormViewModel = {
        return FormViewModel()
    }()

    var willDismissFormVC: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        initViewModel()
    }

    private func initView() {
        submitButton.layer.cornerRadius = 4
    }

    private func initViewModel() {
        viewModel.doneSubmitForm = {
            self.willDismissFormVC?()
            self.dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func touchSubmit(_ sender: Any) {
        viewModel.submitForm()
    }

    @IBAction func touchClose(_ sender: Any) {
        willDismissFormVC?()
        dismiss(animated: true, completion: nil)
    }
}

extension FormViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        SectionType.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch SectionType(rawValue: indexPath.section) {
        case .dueDate:
            let cell = tableView.dequeueReusableCell(withIdentifier: DueDateTableViewCell.id, for: indexPath) as! DueDateTableViewCell
            cell.touchDateBox = {
                tableView.beginUpdates()
                tableView.endUpdates()
            }
            cell.model = viewModel.model
            return cell

        case .category:
            let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.id, for: indexPath) as! CategoryTableViewCell
            cell.model = viewModel.model
            return cell

        case .none:
            return UITableViewCell()
        }
    }
}

