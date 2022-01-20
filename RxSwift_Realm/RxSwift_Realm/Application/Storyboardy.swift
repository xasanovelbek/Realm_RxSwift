//
//  Storyboardy.swift
//  RxSwift_Realm
//
//  Created by Elbek Khasanov on 17/01/22.
//

import UIKit
protocol Storyboardy {
    static func instantiate() -> Self
}

extension UIStoryboard {
    static let main: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    static let datas: UIStoryboard = UIStoryboard(name: "DatasVC", bundle: nil)
}
