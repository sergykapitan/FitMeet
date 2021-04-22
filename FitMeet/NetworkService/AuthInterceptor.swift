//
//  AuthInterceptor.swift
//  FitMeet
//
//  Created by novotorica on 22.04.2021.
//

import Alamofire

struct AuthInterceptor: RequestInterceptor {
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Swift.Result<URLRequest, Error>) -> Void) {
        var adaptedRequest = urlRequest
        guard let token = UserDefaults.standard.string(forKey: Constants.accessTokenKeyUserDefaults) else {
            completion(.success(adaptedRequest))
            return
        }
        adaptedRequest.setValue(token, forHTTPHeaderField: "token")
        completion(.success(adaptedRequest))
    }
    
//    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
//        if let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 {
//            // Handle logout
//            NotificationCenter.default.post(name: .didLogout, object: nil)
//            completion(.doNotRetry)
//        }
//    }
}
