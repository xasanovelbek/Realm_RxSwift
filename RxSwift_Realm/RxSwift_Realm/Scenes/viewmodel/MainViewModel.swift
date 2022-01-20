//
//  MainViewModel.swift
//  RxSwift_Realm
//
//  Created by Elbek Khasanov on 17/01/22.
//

import Foundation
import RxSwift
import RxRelay

class MainViewModel {

    private let manager = DBManager.shared
    
    private let disposeBag = DisposeBag()
    
    let usersRelay = PublishRelay<[UserModel]>()
    
    let errorRelay = PublishRelay<String>()
    
    func addUser(username: String) {
        manager
            .addUser(username: username)
            .subscribe { [weak self] in
                self?.fetchUsers()
            } onError: { [weak self] error in
                self?.errorRelay.accept(self?.getErrorMsg(error) ?? "Unexpected error")
            }
            .disposed(by: disposeBag)
    }
    
    func editUserState(user: UserModel) {
        manager
            .editUserState(user: user)
            .subscribe { [weak self] in
                self?.fetchUsers()
            } onError: { [weak self] error in
                self?.errorRelay.accept(self?.getErrorMsg(error) ?? "Unexpected error")
            }
            .disposed(by: disposeBag)
    }
    
    
    func fetchUsers() {
        manager
            .fetchUsers()
            .asObservable()
            .subscribe { [weak self] users in
                self?.usersRelay.accept(users)
            } onError: { [weak self] error in
                self?.errorRelay.accept(self?.getErrorMsg(error) ?? "Unexpected error")
            }
            .disposed(by: disposeBag)
    }
    
    private func getErrorMsg( _ error: Error) -> String? {
        (error as? RealmError)?.msg
    }
    
}
