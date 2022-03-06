//
//  APIRequestItemType.swift
//  CYPRESS
//
//  Created by Nirav Ramani on 05/03/22.
//

import Foundation
import Alamofire

enum ApiRequestItemsType: String, CaseIterable {
    case albums
    case photos
}

extension ApiRequestItemsType {
    
    var baseURL: String {
       return "https://jsonplaceholder.typicode.com/"
    }
    
    var apiEndPoint: String {
        switch self {
        case .albums:
            return "albums"
        case .photos:
            return "photos"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .albums,.photos:
            return .get
        }
    }
    
    var urlString: String {
        return (baseURL + apiEndPoint).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed).asString()
    }
    
    var url: URL {
        return URL(string: urlString)!
    }

    var headers: HTTPHeaders? {
        let header: HTTPHeaders = [
            "Content-Type": "application/json",
            "X-Requested-With": "XMLHttpRequest"
        ]
        switch self {
        default:
            break
        }
        return header
    }
}
