//
//  DatasVC.swift
//  RxSwift_Realm
//
//  Created by Elbek Khasanov on 18/01/22.
//

import UIKit
import RxSwift
import RxCocoa
class DatasVC: UIViewController, Storyboardy {
    
    static func instantiate() -> Self {
        let storyboard = UIStoryboard.datas
        return storyboard.instantiateInitialViewController() as! Self
    }
    

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    private let bag = DisposeBag()
    
    var user: UserModel?
    
    var clicked: PublishRelay<UserModel?>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = user?.username
        addButton
            .rx
            .tap
            .subscribe { [weak self] _ in
                self?.addButton.pulse()
                self?.clicked?.accept(self?.user)
            }
            .disposed(by: bag)
    }
    
    


 
    
}
