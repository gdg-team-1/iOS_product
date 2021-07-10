//
//  CheckBoxView.swift
//  GDG_Alibi
//
//  Created by chungeunji on 2021/07/08.
//

import UIKit

class CheckBoxView: UIView {

    private let xibName = "CheckBoxView"

    @IBOutlet weak var checkImageView: UIImageView!

    var touchFilter: ((Bool) -> Void)?
    var isSelected: Bool = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        initView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
        initView()
    }

    private func commonInit() {
        let view = Bundle.main.loadNibNamed(xibName, owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        addSubview(view)
    }

    private func initView() {
    }

    @IBAction func touchArea(_ sender: Any) {
        UIImpactFeedbackGenerator().impactOccurred()

        isSelected = !isSelected
        checkImageView.image = isSelected ? UIImage(named: "icCheckBox") : UIImage(named: "icNoneCheckBox")
        touchFilter?(isSelected)
    }
}
