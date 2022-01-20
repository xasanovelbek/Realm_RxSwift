# Realm_RxSwift
This simple app was written to introduce basic operations of some frameworks


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
      
### Here we are initialising our protocl.

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
      
            if let usersResult = self.db?.objects(UserModel.self) {
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
