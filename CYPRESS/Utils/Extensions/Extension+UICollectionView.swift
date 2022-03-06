//
//  Extension+UICollectionView.swift
//  CYPRESS
//
//  Created by Nirav Ramani on 05/03/22.
//

import Foundation
import UIKit

extension UICollectionView {
    func register(_ cellClass: String) {
        self.register(UINib(nibName: cellClass, bundle: nil), forCellWithReuseIdentifier: cellClass)
    }
}
