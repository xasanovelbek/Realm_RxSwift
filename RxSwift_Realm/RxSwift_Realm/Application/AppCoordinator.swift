//
//  AppCoordinator.swift
//  RxSwift_Realm
//
//  Created by Elbek Khasanov on 17/01/22.
//


import UIKit
import RxRelay

protocol AppCoordinatorProtocol {
    func start()
    func startDatasVC(userModel: UserModel, editRelay: PublishRelay<UserModel?>?)
    func showAddUserAlert(_ relay: PublishRelay<String?>)
    func showError(with msg: String)
}
class AppCoordinator: AppCoordinatorProtocol {
    
    private let window: UIWindow
    private let navigationController: UINavigationController
    
    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
        self.window.rootViewController = navigationController
    }
    
    func start() {
        self.window.makeKeyAndVisible()
        let mainVC = MainVC.instantiate()
        mainVC.appCoordinator = self
        mainVC.mainViewModel = MainViewModel()
        self.navigationController.setViewControllers([mainVC], animated: true)
    }
    
    func startDatasVC(userModel: UserModel, editRelay: PublishRelay<UserModel?>?) {
        let vc = DatasVC.instantiate()
        vc.user = userModel
        vc.clicked = editRelay
        self.navigationController.present(vc, animated: true)
    }
    
    func showAddUserAlert(_ relay: PublishRelay<String?>) {
        let alertController = UIAlertController(title: "Add user",
                                                 message: "Enter new users name",
                                                 preferredStyle: .alert)
        
        alertController.addTextField { $0.placeholder = "Add user" }
        
        alertController.addAction(UIAlertAction(title: "Save",
                                                style: .default,
                                                handler: { alert in
            let inputText = alertController.textFields?[0].text
            relay.accept(inputText)
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.navigationController.present(alertController, animated: true)
    }
    
    func showError(with msg: String) {
        let alertController = UIAlertController(title: "Error",
                                                 message: msg,
                                                 preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .cancel))
        self.navigationController.present(alertController, animated: true)
    }
    
    
    
}
