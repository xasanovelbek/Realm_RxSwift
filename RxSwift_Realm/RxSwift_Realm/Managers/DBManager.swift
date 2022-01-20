//
//  DBManager.swift
//  RxSwift_Realm
//
//  Created by Elbek Khasanov on 18/01/22.
//

import Foundation
import RealmSwift
import Realm
import RxSwift
class DBManager {
    
    static let shared: DBManager = {
        let manager = DBManager()
        do {
            manager.db = try Realm()
        } catch {
            print("Realm error")
        }
        return manager
    }()
    
    private var db: Realm?
    
    func addUser(username: String) -> Completable {
        return Completable.create { [weak self] observer in
            let maybeError = RealmError(msg: "Realm add user error")
            
            guard let self = self else {
                observer(.error(maybeError))
                return Disposables.create()
            }
            
            let newUser = UserModel()
            newUser.id = UUID().uuidString
            newUser.username = username
            newUser.selected = false
            
//            /*
            //Remove 2 slashes to test error observer
            
            do {
                try self.db?.write {
                    self.db?.add(newUser)
                    observer(.completed)
                }
            } catch {
                observer(.error(maybeError))
            }
//            */
            
            
            /*
                //Remove stars to test error observer
             
                observer(.error(maybeError))
            */
            return Disposables.create {
                print("Disposable")
            }
        }
    }
    
    func editUserState(user: UserModel) -> Completable {
        return Completable.create { [weak self] observer in
            let maybeError = RealmError(msg: "Realm edit user error")
            
            guard let self = self else {
                observer(.error(maybeError))
                return Disposables.create()
            }
            
            do {
                try self.db?.write {
                    user.selected = !user.selected
                    observer(.completed)
                }
            } catch {
                observer(.error(maybeError))
            }
            return Disposables.create {
                print("Disposable")
            }
        }
    }
    
    func fetchUsers() -> Single<[UserModel]> {
        return Single<[UserModel]>.create { [weak self] observer in
            let maybeError = RealmError(msg: "Realm fetch error")
            
            guard let self = self else {
                observer(.failure(maybeError))
                return Disposables.create()
            }
            
            if let usersResult = self.db?.objects(UserModel.self) {
                let usersArray: [UserModel] = Array(usersResult)
                observer(.success(usersArray))
            } else {
                observer(.failure(maybeError))
            }
            
            return Disposables.create {
                print("Disposable")
            }
        }
    }
}

struct RealmError: Error {
    let msg: String
}
