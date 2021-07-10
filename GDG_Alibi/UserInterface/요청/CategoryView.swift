//
//  CategoryView.swift
//  GDG_Alibi
//
//  Created by chungeunji on 2021/07/10.
//

import UIKit

enum CategoryType: Int {
    case withMe = 0
    case friend
    case background
    case call

    var title: String {
        switch self {
        case .withMe:       return "나와 같이 찍기 📸"
        case .friend:       return "친구 사진만 👩‍❤️‍👨"
        case .background:   return "배경 사진만 🏞"
        case .call:         return "전화 대신 받아주기 ☎️"
        }
    }
}

extension Notification.Name {
    static let selectCategoryType = Notification.Name("selectCategoryTypeNotification")
}

final class CategoryView: UIView {

    private let xibName = "CategoryView"

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkBox: UIImageView!
    @IBOutlet weak var selectButton: UIButton!

    struct Status {
        struct Color {
            static let selected: UIColor = #colorLiteral(red: 0.1725490196, green: 0.7803921569, blue: 0.5058823529, alpha: 1)
            static let deSelected: UIColor = #colorLiteral(red: 0.6666666667, green: 0.6666666667, blue: 0.6666666667, alpha: 1)
        }

        struct Image {
            static let selected: UIImage? = UIImage(named: "icCheckBox")
            static let deSelected: UIImage? = UIImage(named: "icNoneCheckBox")
        }
    }

    var category: CategoryType = .withMe {
        didSet {
            titleLabel.text = category.title
        }
    }

    var selectCategory: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        let view = Bundle.main.loadNibNamed(xibName, owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        addSubview(view)

        NotificationCenter.default.addObserver(self, selector: #selector(handleSelection(_:)), name: .selectCategoryType, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .selectCategoryType, object: nil)
    }

    @IBAction func touchRow(_ sender: Any) {
        setStatus(!selectButton.isSelected)

        NotificationCenter.default.post(name: .selectCategoryType, object: category)
        NotificationCenter.default.post(name: .didChangeFormValue, object: nil)
    }

    public func setStatus(_ isSelected: Bool) {
        selectButton.isSelected = isSelected
        checkBox.image = isSelected ? Status.Image.selected : Status.Image.deSelected
        titleLabel.textColor = isSelected ? Status.Color.selected : Status.Color.deSelected
    }

    @objc func handleSelection(_ notification: Notification) {
        guard let category = notification.object as? CategoryType else { return }

        if category != self.category {
            setStatus(false)
        }
    }
}
