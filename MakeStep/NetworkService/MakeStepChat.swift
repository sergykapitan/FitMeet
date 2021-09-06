//
//  MakeStepChat.swift
//  MakeStep
//
//  Created by novotorica on 02.07.2021.
//

import Foundation
import Alamofire
import Combine

class MakeStepChat {
    
   // let token =

    enum DifferentError: Error {
        case alamofire(wrapped: AFError)
        case malformedURL
    }
   
    //MARK: - create channel
    public func getUser() -> AnyPublisher<TokenChat,DifferentError> {
        return AF.request(Constants.apiEndpoint + "/chat/chats/token", method: .get, encoding: JSONEncoding.default,interceptor: Interceptor(interceptors: [AuthInterceptor()]))
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .publishDecodable(type: TokenChat.self)
            .value()
            .print("TokenChat")
            .mapError{ DifferentError.alamofire(wrapped: $0)}
            .eraseToAnyPublisher()
    }
    // api/v0/chat/chats/history
    
    public func getHistoryMessage(broadId: Int) -> AnyPublisher<HistoryChat,DifferentError> {
        return AF.request(Constants.apiEndpoint + "/chat/chats/history?take=10&broadcastId=\(broadId)", method: .get, encoding: JSONEncoding.default,interceptor: Interceptor(interceptors: [AuthInterceptor()]))
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .publishDecodable(type: HistoryChat.self)
            .value()
            .print("TokenChat")
            .mapError{ DifferentError.alamofire(wrapped: $0)}
            .eraseToAnyPublisher()
    }
}
