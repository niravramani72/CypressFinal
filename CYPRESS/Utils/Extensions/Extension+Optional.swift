//
//  Extension+Optional.swift
//  CYPRESS
//
//  Created by Nirav Ramani on 05/03/22.
//

import Foundation
extension Optional {
    
    func asString() -> String {
        switch self {
        case .some(let value):
            return String(describing: value)
        case _:
            return ""
        }
    }
}
