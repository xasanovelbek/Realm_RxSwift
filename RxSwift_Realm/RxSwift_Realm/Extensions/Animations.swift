//
//  Animations.swift
//  RxSwift_Realm
//
//  Created by Elbek Khasanov on 19/01/22.
//

import UIKit

extension UIButton {
    func pulse() {
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.self.transform = .init(scaleX: 0.9, y: 0.9)
        } completion: { [weak self] _ in
            self?.self.transform = .identity
        }
    }
}
