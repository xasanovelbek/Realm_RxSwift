# Realm_RxSwift
This simple app was written to introduce basic operations of some frameworks. Such as "Realm" and "RxSwift". Also this app was written with MVVM pattern with Coordinators.


# Coordinator
### Here we are declaring our functions with protocol.

      protocol AppCoordinatorProtocol {
          var window: UIWindow { get }
          var navigationController: UINavigationController { get }

          func start()
          func startDatasVC(userModel: UserModel, editRelay: PublishRelay<UserModel?>?)
          func showAddUserAlert(_ relay: PublishRelay<String?>)
          func showError(with msg: String)
      }
      
### Here we are initialising our protocol.

      class AppCoordinator: AppCoordinatorProtocol {

          var window: UIWindow
          var navigationController: UINavigationController

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
      ...
      }



# Realm(Create-Read-Update)

### Create
            let newUser = UserModel()
            newUser.id = UUID().uuidString
            newUser.username = username
            newUser.selected = false

            
            do {
                try db.write {
                    self.db.add(newUser)
                }
            } catch {
                //error
            }
            
### Read(Fetching objects)
      
            if let usersResult = db.objects(UserModel.self) {
                let usersArray: [UserModel] = Array(usersResult)
                print(usersArray)
            } else {
                //error
            }
      
### Update

            do {
                try db.write {
                    user.selected = !user.selected
                }
            } catch {
                    //error    
            }
            
            
# RxSwift Traits   

### Completable
"Completable" is a type of RxSwift traits. "Completable" finishes with 2 functions. First is ".completed", second is ".error(SomeError)". In real use-case, we can use this trait when we need only information about completion or error result. For example when uploading or inserting datas. In this app  I also used "Completable" trait in order to creating new UserModel:

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
            
            do {
                try self.db?.write {
                    self.db?.add(newUser)
                    observer(.completed)
                }
            } catch {
                observer(.error(maybeError))
            }

            return Disposables.create {}
        }
    }

### Single
Second trait type which I used in this application is "Single". In this trait you have 2 chances to finish. First is ".success(SomeData)", second is ".failure(SomeError)". In this app I used this trait in order to fetch users:

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
            
            return Disposables.create {}
        }
    }
    
### Driver
Third trait which I want to introduce is "Driver". This trait is to work with UI. Because this trait works on MainThread. For instance, I used this trait when user opens alert dialog in order to add user and clicks "save" button:
      let alertRelay = PublishRelay<String?>()
      ...
      
         alertRelay
            .asDriver(onErrorJustReturn: "")
            .map { ($0 ?? "") }
            .filter { $0 != "" }
            .drive { [weak self] text in
                self?.addUser(text)
            }
            .disposed(by: bag)
      ...
      
