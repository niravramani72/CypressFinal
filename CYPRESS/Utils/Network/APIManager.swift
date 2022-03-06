//
//  APIManager.swift
//  CYPRESS
//
//  Created by Nirav Ramani on 05/03/22.
//

import Foundation
import Alamofire

public typealias ApiParam = [String: Any]

class NetworkError: Codable {
    let message: String
    let key: String?
}

class APIManager {
    
    //MARK: - Variables
    private let sessionManager: SessionManager
    private let retrier: APIManagerRetrier
    
    //MARK: - Initialization
    init(sessionManager: SessionManager, retrier: APIManagerRetrier) {
        self.sessionManager = sessionManager
        self.retrier = retrier
        self.sessionManager.retrier = self.retrier
    }
    
    convenience init() {
        let urlConfiguration = URLSessionConfiguration.default
        urlConfiguration.timeoutIntervalForRequest = 500
        self.init(sessionManager: SessionManager(configuration: urlConfiguration), retrier: APIManagerRetrier())
    }
    
    
    //MARK: - Class methods
    public func call<T>(type: ApiRequestItemsType, params: ApiParam = .init(), queryParam: ApiParam = .init(), handler: @escaping (Swift.Result<T, AlertMessage>) -> Void) where T: Codable {
        var requestURL = type.url
        
        for key in queryParam.keys {
            if let url = requestURL.appendParameters(whereKey: key, value: queryParam[key]) {
                requestURL = url
            }
        }
        
        self.sessionManager.request(
            requestURL,
            method: type.httpMethod,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: type.headers).validate()
            .responseJSON { (data) in
                self.parseResponse(type: type, data: data, handler: handler)
        }
    }
    
    func parseResponse<T>(
        type: ApiRequestItemsType,
        data: DataResponse<Any>,
        handler: @escaping (Swift.Result<T, AlertMessage>) -> Void) where T: Codable {
        do {
            guard let jsonData = data.data else {
                throw AlertMessage(title: "Error", body: "No data")
            }
            let result = try JSONDecoder().decode(T.self, from: jsonData)
            handler(.success(result))
        } catch {
            if let error = error as? AlertMessage {
                return handler(.failure(error))
            }
            return handler(.failure(self.parseApiError(data: data.data)))
        }
    }
    private func parseApiError(data: Data?) -> AlertMessage {
        if let jsonData = data, let error = try? JSONDecoder().decode(NetworkError.self, from: jsonData) {
            return AlertMessage(title: "Error", body: error.key ?? error.message)
        }
        return AlertMessage(title: "Error", body: "Please try again later")
    }
    
}
extension URL {
    func valueOf(_ queryParamaterName: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == queryParamaterName })?.value
    }
    
    func appendParameters(whereKey queryItem: String, value: Any?) -> URL? {
        guard var urlComponents = URLComponents(string: absoluteString) else { return nil}
        var queryItems: [URLQueryItem] = urlComponents.queryItems ??  []
        let queryItem = URLQueryItem(name: queryItem, value: "\(value ?? "")")
        queryItems.append(queryItem)
        urlComponents.queryItems = queryItems
        return urlComponents.url!
    }
}
class APIManagerRetrier: RequestRetrier {
    
    // MARK: - Vars & Lets
    
    var numberOfRetries = 0
    
    // MARK: - Request Retrier methods
    
    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        if (error.localizedDescription == "The operation couldn’t be completed. Software caused connection abort") {
            completion(true, 1.0) // retry after 1 second
            self.numberOfRetries += 1
        } else if let response = request.task?.response as? HTTPURLResponse, response.statusCode >= 500, self.numberOfRetries < 3 {
            completion(true, 1.0) // retry after 1 second
            self.numberOfRetries += 1
        } else {
            completion(false, 0.0) // don't retry
            self.numberOfRetries = 0
        }
    }
    
}
