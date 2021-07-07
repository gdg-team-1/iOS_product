//
//  APIService.swift
//  GDG_Alibi
//
//  Created by chungeunji on 2021/07/07.
//

import Foundation
import Moya

enum TargetAPI {
    case getList
    case getAlibi(id: String)
    case getMyList(user: String)

    case submitAlibi(form: String)
    case editAlibi(id: String, form: String)
    case deleteAlibi(id: String)
}

extension TargetAPI: TargetType {

    var baseURL: URL { return URL(string: "https://gdg-hackathon-1-team.uc.r.appspot.com")! }

    var path: String {
        switch self {
        case .getList:                      return "/api/v1/alibi"
        case .getAlibi(let id):             return "/api/v1/alibi/\(id)"
        case .getMyList(let user):          return "/api/v1/alibi/search?requestUser={requestUser}"

        case .submitAlibi(_):                  return "/api/v1/alibi"
        case .editAlibi(let id, _):            return "/api/v1/alibi/\(id)"
        case .deleteAlibi(let id):          return "/api/v1/alibi/\(id)"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getList, .getAlibi(_), .getMyList(_):
            return .get
        case .submitAlibi:
            return .post
        case .editAlibi(_, _):
            return .put
        case .deleteAlibi(_):
            return .delete
        }
    }

    var task: Task {
        switch self {
        case .getList, .getAlibi(_), .getMyList(_), .deleteAlibi(_):
            return .requestPlain

        case .submitAlibi(let form), .editAlibi(_, let form):
            let param: [String: Any] = [:]
            return .requestParameters(parameters: param, encoding: URLEncoding.default)
        }
    }

    var sampleData: Data {
        return Data()
    }

    var headers: [String: String]? {
        let param = ["content-type": "application/json",
                     "charset": "request = UTF-8, response = UTF-8"]
        return param
    }
}
