//
//  AlertMessage.swift
//  CYPRESS
//
//  Created by Nirav Ramani on 05/03/22.
//

import Foundation
class AlertMessage: Error {
    
    //MARK: - Variables
    public var title = ""
    public var body = ""
    
    // MARK: - Intialization
    
    public init(title: String, body: String) {
        self.title = title
        self.body = body
    }
    
}

