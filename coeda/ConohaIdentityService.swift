//
//  ConohaIdentityService.swift
//  coeda
//
//  Created by kytiken on 2017/08/22.
//  Copyright © 2017年 kytiken. All rights reserved.
//

import Foundation
import Moya
import RxSwift

enum ConohaIdentityService {
    case tokens(username: String, password: String, tenantId: String)
}

extension ConohaIdentityService: TargetType {
    var baseURL: URL { return URL(string: "https://identity.tyo1.conoha.io/v2.0")! }
    var path: String {
        switch self {
        case .tokens:
            return "/tokens"
        }
    }
    var method: Moya.Method {
        switch self {
        case .tokens:
            return .post
        }
    }
    var parameters: [String: Any]? {
        switch self {
        case .tokens(let username, let password, let tenantId):
            return ["auth": ["passwordCredentials": ["username": username, "password": password]], "tenantId": tenantId]
        }
    }
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .tokens:
            return JSONEncoding.default
        }
    }
    var sampleData: Data {
        switch self {
        case .tokens(let username, _, _):
            return "{ \"access\": { \"token\": { \"issued_at\": \"2015-05-19T07:08:21.927295\", \"expires\": \"2015-05-20T07:08:21Z\", \"id\": \"sample00d88246078f2bexample788f7\", \"tenant\": { \"name\": \"example00000000\", \"enabled\": true, \"tyo1_image_size\": \"550GB\", } ], \"endpoints_links\": [], \"type\": \"mailhosting\", \"name\": \"Mail Hosting Service\" }, { \"endpoints\": [ { \"region\": \"tyo1\", \"publicURL\": \"https://dns-service.tyo1.conoha.io\" } ], \"endpoints_links\": [], \"type\": \"dns\", \"name\": \"DNS Service\" }, { \"endpoints\": [ { \"region\": \"tyo1\", \"publicURL\": \"https://object-storage.tyo1.conoha.io/v1/nc_a4392c0ccba74485abd58ec123eca824\" } ], \"endpoints_links\": [], \"type\": \"object-store\", \"name\": \"Object Storage Service\" }, { \"endpoints\": [ { \"region\": \"sjc1\", \"publicURL\": \"https://identity.sjc1.conoha.io/v2.0\" }, { \"region\": \"tyo1\", \"publicURL\": \"https://identity.tyo1.conoha.io/v2.0\" }, { \"region\": \"sin1\", \"publicURL\": \"https://identity.sin1.conoha.io/v2.0\" } ], \"endpoints_links\": [], \"type\": \"identity\", \"name\": \"Identity Service\" } ], \"user\": { \"username\": \"\(username)\", \"roles_links\": [], \"id\": \"examplea6963c074d7csample12a886ee\", \"roles\": [ { \"name\": \"SwiftOperator\" }, { \"name\": \"_member_\" } ], \"name\": \"example00000000\" }, \"metadata\": { \"is_admin\": 0, \"roles\": [ \"0000000000000000000000000000000e\", \"11111111111111111111111111111113\" ] } }}".data(using: .utf8)!
        }
    }
    var task: Task {
        switch self {
        case .tokens:
            return .request
        }
    }
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
}
