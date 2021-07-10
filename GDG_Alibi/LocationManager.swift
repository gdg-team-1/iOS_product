//
//  LocationManager.swift
//  GDG_Alibi
//
//  Created by chungeunji on 2021/07/10.
//

import Foundation

typealias MyLocationType = (city: String, district: String?, neighbor: String)

final class LocationManager {

    static let shared = LocationManager()

    typealias Dict = [String: String]

    struct Key {
        static let city = "city"
        static let district = "district"
        static let neighbor = "neighbor"
    }

    var cities: [CityModel] = []

    private var location: Dict? {
        if let location = UserDefaults.standard.object(forKey: UserDefaultsKey.myLocation) as? Dict {
            return location
        } else {
            return nil
        }
    }
    var locationString: String { return "\(myCity) \(myDistrict) \(myNeighbor)" }
    var myCity: String { return location?[Key.city] ?? "" }
    var myDistrict: String { return location?[Key.district] ?? "" }
    var myNeighbor: String { return location?[Key.neighbor] ?? "" }

    var isLocationEmpty: Bool { return location == nil }

    // 지역 리스트 지정할 때 사용
    var tempLocation: MyLocationType?

    public func fetchLocationList(completion: @escaping (() -> Void)) {
        guard let path = Bundle.main.path(forResource: "korea", ofType: "json") else { return }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let model = try JSONDecoder().decode(LocalModel.self, from: data)
            cities = model.korea
            completion()
        } catch {
            print("Failed to generate Korea cities")
        }
    }

    public func set(city: String) {
        tempLocation = (city, nil, "")
    }

    public func set(district: String) {
        tempLocation?.district = district
    }

    public func set(neighbor: String) {
        tempLocation?.neighbor = neighbor
    }

    public func saveLocationInfo() {
        guard let myLocation: MyLocationType = tempLocation else { return }
        let dict: Dict = [Key.city: myLocation.city,
                          Key.district: myLocation.district ?? "",
                          Key.neighbor: myLocation.neighbor]
        UserDefaults.standard.setValue(dict, forKey: UserDefaultsKey.myLocation)
        tempLocation = nil
    }
}
