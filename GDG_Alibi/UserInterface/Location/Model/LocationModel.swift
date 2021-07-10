//
//  LocationModel.swift
//  GDG_Alibi
//
//  Created by chungeunji on 2021/07/10.
//

import Foundation

protocol LocationModel {
    
}

public struct LocalModel: Decodable, LocationModel {
    private enum CodingKeys: String, CodingKey {
        case korea
    }
    var korea: [CityModel]
}

public struct CityModel: Decodable, LocationModel {
    private enum CodingKeys: String, CodingKey {
        case cityName = "city_name"
        case districts
    }

    var cityName: String
    var districts: [DistrictModel]
}

public struct DistrictModel: Decodable, LocationModel {
    private enum CodingKeys: String, CodingKey {
        case districtName = "district_name"
        case neighborhoods
    }

    var districtName: String
    var neighborhoods: [String]
}

extension String: LocationModel {}
