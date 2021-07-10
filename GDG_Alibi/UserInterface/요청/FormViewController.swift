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

extension Notification.Name {
    static let didChangeFormValue = Notification.Name("didChangeFormValue")
    static let requestFormatDidEnd = Notification.Name("requestFormatDidEnd")
}

final class FormViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var submitButton: UIButton!

    private lazy var viewModel: FormViewModel = {
        return FormViewModel()
    }()

    struct Status {
        struct Color {
            static let enable: UIColor = #colorLiteral(red: 0.1725490196, green: 0.7803921569, blue: 0.5058823529, alpha: 1)
            static let disable: UIColor = #colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        }
    }

    var willDismissFormVC: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        initViewModel()
        initNotification()
    }

    private func initView() {
        submitButton.layer.cornerRadius = 4

        submitButton.setBackgroundColor(Status.Color.disable, for: .disabled)
        submitButton.setBackgroundColor(Status.Color.enable, for: .normal)
        submitButton.isEnabled = false
    }

    private func initViewModel() {
        viewModel.doneSubmitForm = {
            NotificationCenter.default.post(name: .requestFormatDidEnd, object: self.viewModel.model.dday)

            self.willDismissFormVC?()
            self.dismiss(animated: true, completion: nil)
        }
    }

    private func initNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleValueChange), name: .didChangeFormValue, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .didChangeFormValue, object: nil)
    }

    @objc func handleValueChange() {
        submitButton.isEnabled = viewModel.model.dday != nil && !viewModel.model.category.isEmpty
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

