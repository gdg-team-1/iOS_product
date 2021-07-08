//
//  EmptyView.swift
//  GDG_Alibi
//
//  Created by chungeunji on 2021/07/08.
//

import UIKit

final class EmptyView: UIView {

    private let xibName = "EmptyView"

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

}
