//
//  Extension+UICollectionViewCell.swift
//  CYPRESS
//
//  Created by Nirav Ramani on 05/03/22.
//

import Foundation
import UIKit

extension UICollectionReusableView {
    static var identifier: String {
        return (self.description().split(separator: ".").last?.description).asString()
    }
}
