//
//  LocationTableViewCell.swift
//  GDG_Alibi
//
//  Created by chungeunji on 2021/07/09.
//

import UIKit

final class LocationTableViewCell: UITableViewCell {

    static let id = "LocationTableViewCell"

    @IBOutlet weak var titleLabel: UILabel!

    var model: LocationModel? {
        didSet {
            guard let model = model else { return }

            switch model {
            case let city as CityModel:
                self.accessoryType = LocationManager.shared.tempLocation?.city == city.cityName ? .checkmark : .none
                titleLabel.text = city.cityName
            case let district as DistrictModel:
                self.accessoryType = LocationManager.shared.tempLocation?.district == district.districtName ? .checkmark : .none
                titleLabel.text = district.districtName
            case let neighbor as String:
                self.accessoryType = LocationManager.shared.tempLocation?.neighbor == neighbor ? .checkmark : .none
                titleLabel.text = neighbor
            default:
                break
            }
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        self.accessoryType = .none
    }
}
