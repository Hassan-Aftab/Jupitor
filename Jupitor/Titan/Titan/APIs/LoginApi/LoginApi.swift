//
//  LoginApi.swift
//  Titan
//
//  Created by Hassan Aftab on 17.08.22.
//

import Moya
import RxMoya

enum LoginApi {
    case login(username: String, password: String)
    static var baseUrlString: String  = ""
}

extension LoginApi: TargetType {

    var baseURL: URL {
        return URL(string: "https://" + Self.baseUrlString)!
    }

    var path: String {
        switch self {
        case .login:
            return "v3/master/login"
        }
    }

    var method: Moya.Method {
        switch self {
        case .login:
            return .post
        }
    }

    var sampleData: Data {
        switch self {
        case .login:
            let url = Bundle(for: LoginApiManager.self).url(forResource: "LoginResponseStub", withExtension: "json")
            return try! Data(contentsOf: url!)
        }
    }

    var task: Task {
        switch self {
        case let .login(username: username, password: password):
            let parameters = [
                "email": username,
                "password": password
            ]
            return .requestParameters(parameters: parameters,
                                      encoding: JSONEncoding.default)
        }
    }

    var headers: [String: String]? {
        ["Content-Type": "application/json"]
    }
}
