//
//  FitMeetStream.swift
//  FitMeet
//
//  Created by novotorica on 22.04.2021.
//

import Foundation
import Alamofire
import Combine

class FitMeetStream {
 
    enum DifferentError: Error {
        case alamofire(wrapped: AFError)
        case malformedURL(statusCode: Int)
    }
 
    //MARK: - createBroadcast//POST//AUTH
    public func createBroadcas(broadcast: BroadcastRequest) -> AnyPublisher<BroadcastResponce, DifferentError> {
        print(broadcast.asDictionary())
        return AF.request(Constants.apiEndpoint + "/stream/broadcasts", method: .post, parameters: broadcast.asDictionary(), encoding: JSONEncoding.default,interceptor: Interceptor(interceptors: [AuthInterceptor()]))
                 .publishDecodable(type: BroadcastResponce.self)
                 .value()
                 .print("createBroadcas")
                 .mapError { DifferentError.alamofire(wrapped: $0) }
                 .eraseToAnyPublisher()
           }
    
    //MARK: - list Broadcast//GET

    public func getListBroadcast(id:String) -> AnyPublisher<BroadcastList, DifferentError> {
        print("Id ==============\(id)")
        return AF.request(Constants.apiEndpoint + "/stream/broadcasts/private?order=ASC&page=1&take=10&userId=\(id)", method: .get, encoding: JSONEncoding.default,interceptor: Interceptor(interceptors: [AuthInterceptor()]))
                // .validate(statusCode: 200..<300)
                // .validate(contentType: ["application/json"])
                 .publishDecodable(type: BroadcastList.self)
                 .value()
                 .print("getListBroadcast")
                 .mapError { DifferentError.alamofire(wrapped: $0) }
                 .eraseToAnyPublisher()
           }
    public func getBroadcast() -> AnyPublisher<BroadcastList, DifferentError> {
        return AF.request(Constants.apiEndpoint + "/stream/broadcasts?take=200", method: .get, encoding: JSONEncoding.default,interceptor: Interceptor(interceptors: [AuthInterceptor()]))
                 .validate(statusCode: 200..<300)
                 .validate(contentType: ["application/json"])
                 .publishDecodable(type: BroadcastList.self)
                 .value()
                 .print("getBroadcast")
                 .mapError { DifferentError.alamofire(wrapped: $0) }
                 .eraseToAnyPublisher()
        //interceptor: Interceptor(interceptors: [AuthInterceptor()])
           }
    ///api​/v0​/stream​/broadcasts​/recommended​/private
    public func getRecomandateBroadcast() -> AnyPublisher<BroadcastList, DifferentError> {
        return AF.request(Constants.apiEndpoint + "/stream​/broadcasts​/recommended​/private?order=ASC", method: .get, encoding: JSONEncoding.default,interceptor: Interceptor(interceptors: [AuthInterceptor()]))
                 .validate(statusCode: 200..<300)
                 .validate(contentType: ["application/json"])
                 .publishDecodable(type: BroadcastList.self)
                 .value()
                 .print("getRecomandateBroadcast")
                 .mapError { DifferentError.alamofire(wrapped: $0) }
                 .eraseToAnyPublisher()
           }
    public func getBroadcastSubscription() -> AnyPublisher<BroadcastList, DifferentError> {
        return AF.request(Constants.apiEndpoint + "/stream​/broadcasts​/private?order=ASC&take=200", method: .get, encoding: JSONEncoding.default,interceptor: Interceptor(interceptors: [AuthInterceptor()]))
                 .validate(statusCode: 200..<300)
                 .validate(contentType: ["application/json"])
                 .publishDecodable(type: BroadcastList.self)
                 .value()
                 .print("getBroadcastSubscription")
                 .mapError { DifferentError.alamofire(wrapped: $0) }
                 .eraseToAnyPublisher()
           }

    //MARK: - getBrotcastId//GET//AUTH
    public func getBroadcastId(id: Int) -> AnyPublisher< Bool, DifferentError> {
        return AF.request(Constants.apiEndpoint + "/stream/broadcasts?id=\(id)", method: .get, parameters: [:], encoding: JSONEncoding.default, interceptor: Interceptor(interceptors: [AuthInterceptor()]))
                 .validate(statusCode: 200..<300)
                 .validate(contentType: ["application/json"])
                 .publishDecodable(type: Bool.self)
                 .value()
                 .print("getBroadcastId")
                 .mapError { DifferentError.alamofire(wrapped: $0) }
                 .eraseToAnyPublisher()
           }
    //MARK: - edit BroadcastId//PUT//AUTH
    public func editBroadcastId(id:Int) -> AnyPublisher<ResponceLogin, DifferentError> {
        return AF.request(Constants.apiEndpoint + "/stream/broadcasts?id=\(id)", method: .put, parameters: [:], encoding: JSONEncoding.default, interceptor: Interceptor(interceptors: [AuthInterceptor()]))
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .publishDecodable(type: ResponceLogin.self)
            .value()
            .print("editBroadcastId")
            .mapError{ DifferentError.alamofire(wrapped: $0)}
            .eraseToAnyPublisher()
    }
    //MARK: - Start broadcast id//PUT//AUTH
    public func changePassword(id: Int) -> AnyPublisher<Bool, DifferentError> {
        return AF.request(Constants.apiEndpoint + "/stream/broadcasts/\(id)/start", method: .put, parameters: [:], encoding: JSONEncoding.default, interceptor: Interceptor(interceptors: [AuthInterceptor()]))
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .publishDecodable(type: Bool.self)
            .value()
            .print("changePassword")
            .mapError{ DifferentError.alamofire(wrapped: $0)}
            .eraseToAnyPublisher()
    }
    //MARK: - Stop BroadcastId//PUT//AUTH
    public func stopBroadcastId(id:Int) -> AnyPublisher<ResponceLogin, DifferentError> {
        return AF.request(Constants.apiEndpoint + "/stream/broadcasts?id=\(id)/stop", method: .put, parameters: [:], encoding: JSONEncoding.default, interceptor: Interceptor(interceptors: [AuthInterceptor()]))
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .publishDecodable(type: ResponceLogin.self)
            .value()
            .print("editBroadcastId")
            .mapError{ DifferentError.alamofire(wrapped: $0)}
            .eraseToAnyPublisher()
    }
    //MARK: - Follow broadcast id//AUTH
    public func followBroadcast(id: Int) -> AnyPublisher<Bool, DifferentError> {
        return AF.request(Constants.apiEndpoint + "/stream/broadcasts/\(id)/follow", method: .put, parameters: [:], encoding: JSONEncoding.default, interceptor: Interceptor(interceptors: [AuthInterceptor()]))
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .publishDecodable(type: Bool.self)
            .value()
            .print("changePassword")
            .mapError{ DifferentError.alamofire(wrapped: $0)}
            .eraseToAnyPublisher()
    }
    //MARK: - Un Follow broadcast id//DELETE//AUTH
    public func unFollowBroadcast(id: Int) -> AnyPublisher<Bool, DifferentError> {
        return AF.request(Constants.apiEndpoint + "/stream/broadcasts/\(id)/follow", method: .delete, parameters: [:], encoding: JSONEncoding.default,interceptor: Interceptor(interceptors: [AuthInterceptor()]))
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .publishDecodable(type: Bool.self)
            .value()
            .print("changePassword")
            .mapError{ DifferentError.alamofire(wrapped: $0)}
            .eraseToAnyPublisher()
    }
    //MARK: - Pay Broadcast Id//PUT//AUTH
    public func payBroadcastId(id: Int) -> AnyPublisher<Bool, DifferentError> {
        return AF.request(Constants.apiEndpoint + "/stream/broadcasts/\(id)/sponsor", method: .put, parameters: [:], encoding: JSONEncoding.default, interceptor: Interceptor(interceptors: [AuthInterceptor()]))
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .publishDecodable(type: Bool.self)
            .value()
            .print("changePassword")
            .mapError{ DifferentError.alamofire(wrapped: $0)}
            .eraseToAnyPublisher()
    }
    //MARK: - Get Broadcast Category//GET
    public func getBroadcastCategory() -> AnyPublisher<CategoryResponce, DifferentError> {
        return AF.request(Constants.apiEndpoint + "/stream/broadcastCategories?order=ASC&page=1&take=10", method:.get, parameters: [:])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .publishDecodable(type: CategoryResponce.self)
            .value()
            .print("getBroadcastCategory")
            .mapError{ DifferentError.alamofire(wrapped: $0)}
            .eraseToAnyPublisher()
    }
    //MARK: - Start Stream//POST//AUTH
    public func startStream(stream:StartStream) -> AnyPublisher<StreamResponce, DifferentError> {
        print(stream.asDictionary())
        return AF.request(Constants.apiEndpoint + "/stream/streams", method: .post, parameters: stream.asDictionary(), encoding: JSONEncoding.default, interceptor: Interceptor(interceptors: [AuthInterceptor()]))
            .publishDecodable(type: StreamResponce.self)
            .value()
            .print("startStream")
            .mapError{ DifferentError.alamofire(wrapped: $0)}
            .eraseToAnyPublisher()
    }

    //MARK: - Start Stream Id//PUT//AUTH
    public func startStremId(id: Int) -> AnyPublisher<StreamResponce, DifferentError> {
        
        return AF.request(Constants.apiEndpoint + "/stream/streams/4/start", method:.put,encoding: JSONEncoding.default, interceptor: Interceptor(interceptors: [AuthInterceptor()]))
            .publishDecodable(type: StreamResponce.self)
            .value()
            .print("startStreamid")
            .mapError{ DifferentError.alamofire(wrapped: $0)}
            .eraseToAnyPublisher()
    }
    //MARK: - Stop Stream Id//PUT//AUTH
    public func stopStremId(id: Int) -> AnyPublisher<Bool, DifferentError> {
        return AF.request(Constants.apiEndpoint + "/stream/streams/\(id)/stop", method:.put, parameters: [:], encoding: JSONEncoding.default,interceptor: Interceptor(interceptors: [AuthInterceptor()]))
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .publishDecodable(type: Bool.self)
            .value()
            .print("changePassword")
            .mapError{ DifferentError.alamofire(wrapped: $0)}
            .eraseToAnyPublisher()
    }
    
    
    
    
    
}
