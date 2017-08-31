//
//  ConohaIdentity.swift
//  coeda
//
//  Created by kytiken on 2017/08/25.
//  Copyright © 2017年 kytiken. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import RealmSwift

class ConohaIdentity: Object {
    dynamic var id = ""
    dynamic var user: User?
    dynamic var tenant: Tenant?
    dynamic var token: Token?
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func setId() -> Bool {
        self.id = generateId()
        return true
    }
    
    func generateId() -> String {
        return "\(user?.name ?? "")\(tenant?.id ?? "")"
    }
    

}
