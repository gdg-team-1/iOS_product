//
//  CategoryTableViewCell.swift
//  GDG_Alibi
//
//  Created by chungeunji on 2021/07/08.
//

import UIKit

final class CategoryTableViewCell: UITableViewCell {

    static let id = "CategoryTableViewCell"

    @IBOutlet var categoryViews: [CategoryView]!

    var model: FormModel?

    override func awakeFromNib() {
        super.awakeFromNib()

        initView()
        initNotification()
    }

    private func initView() {
        categoryViews.forEach({ $0.category = CategoryType(rawValue: $0.tag) ?? .withMe })
    }

    private func initNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleSelection(_:)), name: .selectCategoryType, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .selectCategoryType, object: nil)
    }

    @objc func handleSelection(_ notification: Notification) {
        guard let category = notification.object as? CategoryType else { return }

        if model?.category.contains(category.title) ?? false {
            model?.category.removeAll()
        } else {
            model?.category.removeAll()
            model?.category.append(category.title)
        }
    }
}
