//
//  CategoryTableViewCell.swift
//  GDG_Alibi
//
//  Created by chungeunji on 2021/07/08.
//

import UIKit

final class CategoryTableViewCell: UITableViewCell {

    static let id = "CategoryTableViewCell"

    @IBOutlet var boxViews: [UIView]!
    @IBOutlet var checkImageViews: [UIImageView]!
    @IBOutlet var categoryLabels: [UILabel]!

    var chips: [String] = ["나와 같이 찍기", "친구 사진만", "배경 사진만", "전화 대신 받아주기"]

    var model: FormModel? {
        didSet {
            
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        initView()
    }

    private func initView() {
        boxViews.forEach({
            $0.layer.borderWidth = 1
            $0.layer.borderColor = #colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
            $0.layer.cornerRadius = 17
        })
    }

    @IBAction func selectCategory(_ sender: UIButton) {
        let tag = sender.tag
        checkImageViews.forEach({ $0.isHidden = $0.tag != tag })
        boxViews.forEach({
            $0.layer.borderColor = $0.tag == tag ? #colorLiteral(red: 0.1725490196, green: 0.7803921569, blue: 0.5058823529, alpha: 1) : #colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
            $0.backgroundColor = $0.tag == tag ? #colorLiteral(red: 0.1725490196, green: 0.7803921569, blue: 0.5058823529, alpha: 1) : .systemBackground
        })
        categoryLabels.forEach({ $0.textColor = $0.tag == tag ? .white :  #colorLiteral(red: 0.6666666667, green: 0.6666666667, blue: 0.6666666667, alpha: 1) })
        model?.category.append(chips[tag])
    }
}
