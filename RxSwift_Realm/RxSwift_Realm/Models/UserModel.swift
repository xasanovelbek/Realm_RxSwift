//
//  UserModel.swift
//  RxSwift_Realm
//
//  Created by Elbek Khasanov on 17/01/22.
//

import Foundation
import RealmSwift

class UserModel: Object {
    @Persisted var id: String
    @Persisted var username: String?
    @Persisted var selected: Bool
}
