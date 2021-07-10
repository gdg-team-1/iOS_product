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
    case getMyList(user: String, dueDate: String, location: String)

    case submitAlibi(form: FormModel)
    case editAlibi(id: String, form: FormModel)
    case deleteAlibi(id: String)

    case getUserInfo(id: String)
    case submitUser(user: UserModel)
    case editUser(id: String, user: UserModel)
    case profileUpload(data: UIImage)
}

extension TargetAPI: TargetType {

    var baseURL: URL { return URL(string: "https://gdg-hackathon-1-team.uc.r.appspot.com")! }

    var path: String {
        switch self {
        case .getList:                                              return "/api/v1/alibi"
        case .getAlibi(let id):                                     return "/api/v1/alibi/\(id)"
        case .getMyList(_, _, _):                                   return "/api/v1/alibi/search"
        case .submitAlibi(_):                                       return "/api/v1/alibi"
        case .editAlibi(let id, _):                                 return "/api/v1/alibi/\(id)"
        case .deleteAlibi(let id):                                  return "/api/v1/alibi/\(id)"
        case .getUserInfo(let id):                                  return "/api/v1/user/detail/\(id)"
        case .submitUser(_):                                        return "/api/v1/user"
        case .editUser(let id, _):                                  return "/api/v1/user/detail/\(id)"
        case .profileUpload(_):                                     return "/api/v1/user/imageFileUpLoad"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getList, .getAlibi(_), .getMyList(_, _, _), .getUserInfo(_):
            return .get
        case .submitAlibi, .submitUser(_), .profileUpload(_):
            return .post
        case .editAlibi(_, _), .editUser(_, _):
            return .put
        case .deleteAlibi(_):
            return .delete
        }
    }

    var task: Task {
        switch self {
        case .getList, .getAlibi(_), .deleteAlibi(_), .getUserInfo(_):
            return .requestPlain

        case .getMyList(let user, let dueDate, let location):
            let param: [String: Any] = ["requestUser": user, "dDay": dueDate, "location": location]
            return .requestParameters(parameters: param, encoding: URLEncoding.default)

        case .submitAlibi(let form), .editAlibi(_, let form):
            return .requestJSONEncodable(form)

        case .submitUser(let user), .editUser(_, let user):
            return .requestJSONEncodable(user)

        case .profileUpload(let data):
            let image = data.jpegData(compressionQuality: 0.20)
            let attachmentImage = MultipartFormData(provider: .data(image!), name: "file", fileName: "image.jpg", mimeType: "image/jpeg")
            let multipartData = [attachmentImage]
            return .uploadMultipart(multipartData)
        }
    }

    var sampleData: Data {
        return Data()
    }

    var headers: [String: String]? {
        switch self {
        case .profileUpload(_):
            let param = ["Content-Type": "multipart/form-data"]
            return param

        default:
            let param = ["Content-Type": "application/json",
                         "charset": "request = UTF-8, response = UTF-8"]
            return param
        }
    }
}
