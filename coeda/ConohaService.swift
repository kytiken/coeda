//
//  ConohaService.swift
//  coeda
//
//  Created by kytiken on 2017/08/22.
//  Copyright © 2017年 kytiken. All rights reserved.
//

import Foundation
import Foundation
import Moya

enum ConohaService {
    case zen
    case showUser(id: Int)
    case createUser(firstName: String, lastName: String)
    case updateUser(id:Int, firstName: String, lastName: String)
    case showAccounts
}

extension ConohaService: TargetType {
    var baseURL: URL { return URL(string: "https://google.com")! }
    var path: String {
        switch self {
        case .zen:
            return "/"
        case .showUser(let id), .updateUser(let id, _, _):
            return "/users/\(id)"
        case .createUser(_, _):
            return "/users"
        case .showAccounts:
            return "/accounts"
        }
    }
    var method: Moya.Method {
        switch self {
        case .zen, .showUser, .showAccounts:
            return .get
        case .createUser, .updateUser:
            return .post
        }
    }
    var parameters: [String: Any]? {
        switch self {
        case .zen, .showUser, .showAccounts:
            return nil
        case .createUser(let firstName, let lastName), .updateUser(_, let firstName, let lastName):
            return ["first_name": firstName, "last_name": lastName]
        }
    }
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .zen, .showUser, .showAccounts:
            return URLEncoding.default // Send parameters in URL for GET, DELETE and HEAD. For other HTTP methods, parameters will be sent in request body
        case .updateUser:
            return URLEncoding.queryString // Always sends parameters in URL, regardless of which HTTP method is used
        case .createUser:
            return JSONEncoding.default // Send parameters as JSON in request body
        }
    }
    var sampleData: Data {
        switch self {
        case .zen:
            return Data()
        case .showUser( _):
            return Data()
        case .createUser( _, _):
            return Data()
        case .updateUser( _, _, _):
            return Data()
        case .showAccounts:
            return Data()
        }
    }
    var task: Task {
        switch self {
        case .zen, .showUser, .createUser, .updateUser, .showAccounts:
            return .request
        }
    }
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
}
