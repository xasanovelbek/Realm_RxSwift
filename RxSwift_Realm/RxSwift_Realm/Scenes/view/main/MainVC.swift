
import UIKit
import RxSwift
import RxCocoa
class MainVC: UIViewController, Storyboardy {
    
    static func instantiate() -> Self {
        let storyboard = UIStoryboard.main
        return storyboard.instantiateInitialViewController() as! Self
    }
    
    // MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: Properties
    var mainViewModel: MainViewModel?
    
    private let bag = DisposeBag()
    
    // MARK: Delegates
    var appCoordinator: AppCoordinatorProtocol?
    
    // MARK: OBSERVABLES
    let alertRelay = PublishRelay<String?>()
    let editRelay = PublishRelay<UserModel?>()
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        bindViews()
        bindDelegates()
        loadUsers()
        
    }
    
    // MARK: CONFIGURATIONS
    private func configureViews() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                                 target: self,
                                                                 action: #selector(addClicked))
    }
    
    // MARK: BINDINGS
    private func bindViews() {
        mainViewModel?
            .usersRelay
            .asDriver(onErrorJustReturn: [])
            .map { list -> [UserModel] in
                return list.filter({ $0.username != nil })
            }
            .map { list -> [UserModel] in
                return list.filter { [weak self] userModel in
                    guard let text = self?.searchBar.text?.lowercased() else { return true }
                    if text.isEmpty { return true }
                    let isContains = (userModel.username?.lowercased().contains(text) ?? false)
                    return isContains
                }
            }
            .drive(tableView
                    .rx
                    .items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { row, element, cell in
                cell.textLabel?.text = element.username
                let img = element.selected ? UIImage(named: "tick") : UIImage(named: "")
                cell.imageView?.image = img
            }
            .disposed(by: bag)
    }
    
    private func bindDelegates() {
        tableView
            .rx
            .modelSelected(UserModel.self)
            .filter { $0.username != nil }
            .subscribe { [weak self] userModel in
                self?.appCoordinator?.startDatasVC(userModel: userModel,
                                                   editRelay: self?.editRelay)
            }
            .disposed(by: bag)
        
        searchBar
            .rx
            .text
            .orEmpty
            .asDriver()
            .drive { [weak self] text in
                self?.loadUsers()
            }
            .disposed(by: bag)
        
        alertRelay
            .asDriver(onErrorJustReturn: "")
            .map { ($0 ?? "") }
            .filter { $0 != "" }
            .drive { [weak self] text in
                self?.addUser(text)
            }
            .disposed(by: bag)
        
        editRelay
            .asDriver(onErrorJustReturn: nil)
            .drive { [weak self] user in
                if let user = user {
                    self?.mainViewModel?.editUserState(user: user)
                }
            }
            .disposed(by: bag)

        mainViewModel?
            .errorRelay
            .asDriver(onErrorJustReturn: "Unexpected error")
            .drive { [weak self] text in
                self?.showError(with: text)
            }
            .disposed(by: bag)
    }
    
    // MARK: WORK WITH DATAS
    private func loadUsers() {
        mainViewModel?.fetchUsers()
    }
    
    private func addUser(_ username: String) {
        mainViewModel?.addUser(username: username)
    }
    
    // MARK: COORDINATE
    @objc func addClicked() {
        appCoordinator?.showAddUserAlert(alertRelay)
    }

    private func showError(with msg: String) {
        appCoordinator?.showError(with: msg)
    }

}

