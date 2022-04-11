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
        return AF.request(Constants.apiEndpoint + "/stream/broadcasts", method: .post, parameters: broadcast.asDictionary(), encoding: JSONEncoding.default,interceptor: Interceptor(interceptors: [AuthInterceptor()]))
                 .publishDecodable(type: BroadcastResponce.self)
                 .value()
                 .print("createBroadcas")
                 .mapError { DifferentError.alamofire(wrapped: $0) }
                 .eraseToAnyPublisher()
           }
    public func deleteBroadcast(id: Int) -> AnyPublisher<BroadcastResponce, DifferentError> {
        return AF.request(Constants.apiEndpoint + "/stream/broadcasts/\(id)", method: .delete, encoding: JSONEncoding.default,interceptor: Interceptor(interceptors: [AuthInterceptor()]))
                 .validate(statusCode: 200..<300)
                 .validate(contentType: ["application/json"])
                 .publishDecodable(type: BroadcastResponce.self)
                 .value()
                 .mapError { DifferentError.alamofire(wrapped: $0) }
                 .eraseToAnyPublisher()
           }
    public func getNotPlanBroadcast() -> AnyPublisher<BroadcastList, DifferentError> {
        return AF.request(Constants.apiEndpoint + "/stream/broadcasts?take=200&status=PLANNED", method: .get, encoding: JSONEncoding.default,interceptor: Interceptor(interceptors: [AuthInterceptor()]))
                 .validate(statusCode: 200..<300)
                 .validate(contentType: ["application/json"])
                 .publishDecodable(type: BroadcastList.self)
                 .value()
                 .mapError { DifferentError.alamofire(wrapped: $0) }
                 .eraseToAnyPublisher()
           }
    public func getNotOffBroadcast() -> AnyPublisher<BroadcastList, DifferentError> {
        return AF.request(Constants.apiEndpoint + "/stream/broadcasts?take=200&status=OFFLINE&type=STANDARD_VOD", method: .get, encoding: JSONEncoding.default,interceptor: Interceptor(interceptors: [AuthInterceptor()]))
                 .validate(statusCode: 200..<300)
                 .validate(contentType: ["application/json"])
                 .publishDecodable(type: BroadcastList.self)
                 .value()
                 .mapError { DifferentError.alamofire(wrapped: $0) }
                 .eraseToAnyPublisher()
           }
    //MARK: - list Broadcast//GET
    public func getListBroadcast(status:String) -> AnyPublisher<BroadcastList, DifferentError> {
        return AF.request(Constants.apiEndpoint + "/stream/broadcasts/private?take=10&status=\(status)", method: .get, encoding: JSONEncoding.default,interceptor: Interceptor(interceptors: [AuthInterceptor()]))
                 .validate(statusCode: 200..<300)
                 .validate(contentType: ["application/json"])
                 .publishDecodable(type: BroadcastList.self)
                 .value()
                 .mapError { DifferentError.alamofire(wrapped: $0) }
                 .eraseToAnyPublisher()
           }
    public func getListPlanBroadcast() -> AnyPublisher<BroadcastList, DifferentError> {
        return AF.request(Constants.apiEndpoint + "/stream/broadcasts/private?take=200&status=PLANNED", method: .get, encoding: JSONEncoding.default,interceptor: Interceptor(interceptors: [AuthInterceptor()]))
                 .validate(statusCode: 200..<300)
                 .validate(contentType: ["application/json"])
                 .publishDecodable(type: BroadcastList.self)
                 .value()
                 .mapError { DifferentError.alamofire(wrapped: $0) }
                 .eraseToAnyPublisher()
           }
    public func getOffBroadcast(page: Int) -> AnyPublisher<BroadcastList, DifferentError> {
        return AF.request(Constants.apiEndpoint + "/stream/broadcasts/private?page=\(page)&take=12&sort=viewersCount&status=OFFLINE&type=STANDARD_VOD", method: .get, encoding: JSONEncoding.default,interceptor: Interceptor(interceptors: [AuthInterceptor()]))
                 .validate(statusCode: 200..<300)
                 .validate(contentType: ["application/json"])
                 .publishDecodable(type: BroadcastList.self)
                 .value()
                 .mapError { DifferentError.alamofire(wrapped: $0) }
                 .eraseToAnyPublisher()
           }
 
    public func getListAllBroadcast() -> AnyPublisher<BroadcastList, DifferentError> {
        return AF.request(Constants.apiEndpoint + "/stream/broadcasts/private?take=200&sort=type", method: .get, encoding: JSONEncoding.default,interceptor: Interceptor(interceptors: [AuthInterceptor()]))
                 .validate(statusCode: 200..<300)
                 .validate(contentType: ["application/json"])
                 .publishDecodable(type: BroadcastList.self)
                 .value()
                 .mapError { DifferentError.alamofire(wrapped: $0) }
                 .eraseToAnyPublisher()
           }
 
    
    public func getListFollowBroadcast(status:String,follow: Bool) -> AnyPublisher<BroadcastList, DifferentError> {
        return AF.request(Constants.apiEndpoint + "/stream/broadcasts/private?take=200&status=\(status)&isFollow=\(follow)", method: .get, encoding: JSONEncoding.default,interceptor: Interceptor(interceptors: [AuthInterceptor()]))
                  .validate(statusCode: 200..<300)
                  .validate(contentType: ["application/json"])
                 .publishDecodable(type: BroadcastList.self)
                 .value()
                 .print("getListBroadcast")
                 .mapError { DifferentError.alamofire(wrapped: $0) }
                 .eraseToAnyPublisher()
           }
   
    public func getBroadcast(status: String) -> AnyPublisher<BroadcastList, DifferentError> {
        return AF.request(Constants.apiEndpoint + "/stream/broadcasts?take=200&status=\(status)", method: .get, encoding: JSONEncoding.default,interceptor: Interceptor(interceptors: [AuthInterceptor()]))
                 .validate(statusCode: 200..<300)
                 .validate(contentType: ["application/json"])
                 .publishDecodable(type: BroadcastList.self)
                 .value()
                 .print("getBroadcast")
                 .mapError { DifferentError.alamofire(wrapped: $0) }
                 .eraseToAnyPublisher()
        
           }
    //&type=STANDARD_VOD"
    public func getBroadcastPrivate(status: String,userId: String,type: String) -> AnyPublisher<BroadcastList, DifferentError> {
        return AF.request(Constants.apiEndpoint + "/stream/broadcasts/private?take=100&status=\(status)&sort=userId&userId=\(userId)&type=\(type)", method: .get, encoding: JSONEncoding.default,interceptor: Interceptor(interceptors: [AuthInterceptor()]))
                 .validate(statusCode: 200..<300)
                 .validate(contentType: ["application/json"])
                 .publishDecodable(type: BroadcastList.self)
                 .value()
                 .print("getBroadcastPrivate")
                 .mapError { DifferentError.alamofire(wrapped: $0) }
                 .eraseToAnyPublisher()
        
           }
    public func getBroadcastPrivateTime(status: String,userId: String) -> AnyPublisher<BroadcastList, DifferentError> {
        return AF.request(Constants.apiEndpoint + "/stream/broadcasts/private?take=50&status=\(status)&sort=scheduledStartDate&userId=\(userId)", method: .get, encoding: JSONEncoding.default,interceptor: Interceptor(interceptors: [AuthInterceptor()]))
                 .validate(statusCode: 200..<300)
                 .validate(contentType: ["application/json"])
                 .publishDecodable(type: BroadcastList.self)
                 .value()
                 .print("getBroadcastPrivate")
                 .mapError { DifferentError.alamofire(wrapped: $0) }
                 .eraseToAnyPublisher()
        
           }
    public func getBroadcastPrivateChannel(userId: String,page: Int) -> AnyPublisher<BroadcastList, DifferentError> {
        return AF.request(Constants.apiEndpoint + "/stream/broadcasts/private?page=\(page)&take=10&sort=scheduledStartDate&userId=\(userId)", method: .get, encoding: JSONEncoding.default,interceptor: Interceptor(interceptors: [AuthInterceptor()]))
                 .validate(statusCode: 200..<300)
                 .validate(contentType: ["application/json"])
                 .publishDecodable(type: BroadcastList.self)
                 .value()
                 .print("getBroadcastPrivate")
                 .mapError { DifferentError.alamofire(wrapped: $0) }
                 .eraseToAnyPublisher()
        
           }
    public func getBroadcastNotAuth(status: String,userId: String) -> AnyPublisher<BroadcastList, DifferentError> {
        return AF.request(Constants.apiEndpoint + "/stream/broadcasts?take=200&status=\(status)&sort=userId&userId=\(userId)", method: .get, encoding: JSONEncoding.default)
                 .validate(statusCode: 200..<300)
                 .validate(contentType: ["application/json"])
                 .publishDecodable(type: BroadcastList.self)
                 .value()
                 .print("getBroadcast")
                 .mapError { DifferentError.alamofire(wrapped: $0) }
                 .eraseToAnyPublisher()
        
           }
    public func getBroadcastPrivateID(userId: String) -> AnyPublisher<BroadcastList, DifferentError> {
        return AF.request(Constants.apiEndpoint + "/stream/broadcasts/private?take=200&sort=userId&userId=\(userId)", method: .get, encoding: JSONEncoding.default,interceptor: Interceptor(interceptors: [AuthInterceptor()]))
                 .validate(statusCode: 200..<300)
                 .validate(contentType: ["application/json"])
                 .publishDecodable(type: BroadcastList.self)
                 .value()
                 .print("getBroadcast")
                 .mapError { DifferentError.alamofire(wrapped: $0) }
                 .eraseToAnyPublisher()
        
           }
   //&type=\(type)
    public func getBroadcastPrivateVOD(userId: String,page: Int,type: String ) -> AnyPublisher<BroadcastList, DifferentError> {
        return AF.request(Constants.apiEndpoint + "/stream/broadcasts/private?order=ASC&page=\(page)&take=10&userId=\(userId)", method: .get, encoding: JSONEncoding.default,interceptor: Interceptor(interceptors: [AuthInterceptor()]))
                 .validate(statusCode: 200..<300)
                 .validate(contentType: ["application/json"])
                 .publishDecodable(type: BroadcastList.self)
                 .value()
                // .print("getBroadcast")
                 .mapError { DifferentError.alamofire(wrapped: $0) }
                 .eraseToAnyPublisher()
        
           }
    public func getBroadcastPrivateVODNotAuth(userId: String,page: Int,type: String ) -> AnyPublisher<BroadcastList, DifferentError> {
        return AF.request(Constants.apiEndpoint + "/stream/broadcasts?order=ASC&page=\(page)&take=10&userId=\(userId)", method: .get, encoding: JSONEncoding.default)
                 .validate(statusCode: 200..<300)
                 .validate(contentType: ["application/json"])
                 .publishDecodable(type: BroadcastList.self)
                 .value()
                 //.print("getBroadcast")
                 .mapError { DifferentError.alamofire(wrapped: $0) }
                 .eraseToAnyPublisher()
        
           }
    public func getBroadcastPrivateMulty(userId: String) -> AnyPublisher<BroadcastList, DifferentError> {
        return AF.request(Constants.apiEndpoint + "/stream/broadcasts/private?order=ASC&page=1&take=10&userId=\(userId)&type=MULTI", method: .get, encoding: JSONEncoding.default,interceptor: Interceptor(interceptors: [AuthInterceptor()]))
                 //.validate(statusCode: 200..<300)
                 .validate(contentType: ["application/json"])
                 .publishDecodable(type: BroadcastList.self)
                 .value()
                 .print("getBroadcast")
                 .mapError { DifferentError.alamofire(wrapped: $0) }
                 .eraseToAnyPublisher()
        
           }
    public func getAllBroadcast(name: String) -> AnyPublisher<BroadcastList, DifferentError> {
        return AF.request(Constants.apiEndpoint + "/stream/broadcasts?take=200&nameLike=\(name)", method: .get, encoding: JSONEncoding.default,interceptor: Interceptor(interceptors: [AuthInterceptor()]))
                 .validate(statusCode: 200..<300)
                 .validate(contentType: ["application/json"])
                 .publishDecodable(type: BroadcastList.self)
                 .value()
                 .print("getBroadcast")
                 .mapError { DifferentError.alamofire(wrapped: $0) }
                 .eraseToAnyPublisher()
        
           }
    public func getAllBroadcastPrivate(name: String) -> AnyPublisher<BroadcastList, DifferentError> {
        return AF.request(Constants.apiEndpoint + "/stream/broadcasts/private?take=200&sort=followersCount&nameLike=\(name)", method: .get, encoding: JSONEncoding.default,interceptor: Interceptor(interceptors: [AuthInterceptor()]))
                 .validate(statusCode: 200..<300)
                 .validate(contentType: ["application/json"])
                 .publishDecodable(type: BroadcastList.self)
                 .value()
                 .print("getBroadcast")
                 .mapError { DifferentError.alamofire(wrapped: $0) }
                 .eraseToAnyPublisher()
        
           }
    public func getAllBroadcastNotAuth(name: String) -> AnyPublisher<BroadcastList, DifferentError> {
        return AF.request(Constants.apiEndpoint + "/stream/broadcasts?take=200&nameLike=\(name)", method: .get, encoding: JSONEncoding.default,interceptor: Interceptor(interceptors: [AuthInterceptor()]))
                 .validate(statusCode: 200..<300)
                 .validate(contentType: ["application/json"])
                 .publishDecodable(type: BroadcastList.self)
                 .value()
                 .print("getBroadcast")
                 .mapError { DifferentError.alamofire(wrapped: $0) }
                 .eraseToAnyPublisher()
        
           }
    ///stream/broadcasts?take=200&broadcastCategoryId=\(categoryId)
    public func getBroadcastCategoryId(categoryId: Int,page: Int) -> AnyPublisher<BroadcastList, DifferentError> {
        return AF.request(Constants.apiEndpoint + "/stream/broadcasts/private?page=\(page)&take=10&broadcastCategoryId=\(categoryId)", method: .get, encoding: JSONEncoding.default,interceptor: Interceptor(interceptors: [AuthInterceptor()]))
                 .validate(statusCode: 200..<300)
                 .validate(contentType: ["application/json"])
                 .publishDecodable(type: BroadcastList.self)
                 .value()
                 .print("getBroadcastCategory")
                 .mapError { DifferentError.alamofire(wrapped: $0) }
                 .eraseToAnyPublisher()
        
           }
    public func getBroadcastCategoryIdNotAuth(categoryId: Int) -> AnyPublisher<BroadcastList, DifferentError> {
        return AF.request(Constants.apiEndpoint + "/stream/broadcasts?take=200&broadcastCategoryId=\(categoryId)", method: .get, encoding: JSONEncoding.default,interceptor: Interceptor(interceptors: [AuthInterceptor()]))
                 .validate(statusCode: 200..<300)
                 .validate(contentType: ["application/json"])
                 .publishDecodable(type: BroadcastList.self)
                 .value()
                 .print("getBroadcastCategory")
                 .mapError { DifferentError.alamofire(wrapped: $0) }
                 .eraseToAnyPublisher()
        
           }
    public func getRecomandateBroadcast() -> AnyPublisher<BroadcastList, DifferentError> {
        return AF.request(Constants.apiEndpoint + "/stream/broadcasts/recommended/private?order=ASC", method: .get, encoding: JSONEncoding.default,interceptor: Interceptor(interceptors: [AuthInterceptor()]))
                 .validate(statusCode: 200..<300)
                 .validate(contentType: ["application/json"])
                 .publishDecodable(type: BroadcastList.self)
                 .value()
                 .print("getRecomandateBroadcast")
                 .mapError { DifferentError.alamofire(wrapped: $0) }
                 .eraseToAnyPublisher()
           }
    public func getBroadcastSubscription() -> AnyPublisher<BroadcastList, DifferentError> {
        return AF.request(Constants.apiEndpoint + "/stream/broadcasts/private?&take=40&isSubscribe=true", method: .get, encoding: JSONEncoding.default,interceptor: Interceptor(interceptors: [AuthInterceptor()]))
                 .validate(statusCode: 200..<300)
                 .validate(contentType: ["application/json"])
                 .publishDecodable(type: BroadcastList.self)
                 .value()
                 .print("getBroadcastSubscription")
                 .mapError { DifferentError.alamofire(wrapped: $0) }
                 .eraseToAnyPublisher()
           }
//?privateUrlKey=ca3bb948-19a0-4ec3-957a-bb02b100076c
    public func getBroadcastId(id: String,key:String) -> AnyPublisher< BroadcastResponce, DifferentError> {
        return AF.request(Constants.apiEndpoint + "/stream/broadcasts/\(id)?privateUrlKey=\(key)", method: .get, encoding: JSONEncoding.default)
                 .validate(statusCode: 200..<300)
                 .validate(contentType: ["application/json"])
                 .publishDecodable(type: BroadcastResponce.self)
                 .value()
                 .print("getBroadcastId")
                 .mapError { DifferentError.alamofire(wrapped: $0) }
                 .eraseToAnyPublisher()
           }
    public func getBroadcastId(id: String) -> AnyPublisher< BroadcastResponce, DifferentError> {
        return AF.request(Constants.apiEndpoint + "/stream/broadcasts/\(id)", method: .get, encoding: JSONEncoding.default)
                 .validate(statusCode: 200..<300)
                 .validate(contentType: ["application/json"])
                 .publishDecodable(type: BroadcastResponce.self)
                 .value()
                 .print("getBroadcastId")
                 .mapError { DifferentError.alamofire(wrapped: $0) }
                 .eraseToAnyPublisher()
           }
    //MARK: - startBrotcastId//GET//AUTH //stream/broadcasts/7
    public func startBroadcastId(id: Int) -> AnyPublisher< BroadcastResponce, DifferentError> {
        return AF.request(Constants.apiEndpoint + "/stream/broadcasts/\(id)/start", method: .put, parameters: [:], encoding: JSONEncoding.default, interceptor: Interceptor(interceptors: [AuthInterceptor()]))
                 .validate(statusCode: 200..<300)
                 .validate(contentType: ["application/json"])
                 .publishDecodable(type: BroadcastResponce.self)
                 .value()
                 .mapError { DifferentError.alamofire(wrapped: $0) }
                 .eraseToAnyPublisher()
           }
    //MARK: - edit BroadcastId//PUT//AUTH
    public func editBroadcastId(id:Int, broadcast: EditBroadcast) -> AnyPublisher<BroadcastResponce, DifferentError> {
        return AF.request(Constants.apiEndpoint + "/stream/broadcasts/\(id)", method: .put, parameters: broadcast.asDictionary(), encoding: JSONEncoding.default, interceptor: Interceptor(interceptors: [AuthInterceptor()]))
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .publishDecodable(type: BroadcastResponce.self)
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
        return AF.request(Constants.apiEndpoint + "/stream/broadcasts/\(id)/stop", method: .put, parameters: [:], encoding: JSONEncoding.default, interceptor: Interceptor(interceptors: [AuthInterceptor()]))
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .publishDecodable(type: ResponceLogin.self)
            .value()
            .print("stopBroadcastId")
            .mapError{ DifferentError.alamofire(wrapped: $0)}
            .eraseToAnyPublisher()
    }
    //MARK: - Follow broadcast id//AUTH
    public func followBroadcast(id: Int) -> AnyPublisher<BroadcastResponce, DifferentError> {
        return AF.request(Constants.apiEndpoint + "/stream/broadcasts/\(id)/follow", method: .put, encoding: JSONEncoding.default, interceptor: Interceptor(interceptors: [AuthInterceptor()]))
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .publishDecodable(type: BroadcastResponce.self)
            .value()
            .print("followBroadcast")
            .mapError{ DifferentError.alamofire(wrapped: $0)}
            .eraseToAnyPublisher()
    }
    //MARK: - Un Follow broadcast id//DELETE//AUTH
    public func unFollowBroadcast(id: Int) -> AnyPublisher<BroadcastResponce, DifferentError> {
        return AF.request(Constants.apiEndpoint + "/stream/broadcasts/\(id)/follow", method: .delete, parameters: [:], encoding: JSONEncoding.default,interceptor: Interceptor(interceptors: [AuthInterceptor()]))
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .publishDecodable(type: BroadcastResponce.self)
            .value()
            .print("UnFollowBroadcast")
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
            .mapError{ DifferentError.alamofire(wrapped: $0)}
            .eraseToAnyPublisher()
    }

    public func getCategoryPrivate() -> AnyPublisher<CategoryResponce,DifferentError> {
        return AF.request(Constants.apiEndpoint + "/stream/broadcastCategories/private?take=40", method: .get, encoding: JSONEncoding.default,interceptor: Interceptor(interceptors: [AuthInterceptor()]))
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .publishDecodable(type: CategoryResponce.self)
            .value()
            .mapError{ DifferentError.alamofire(wrapped: $0)}
            .eraseToAnyPublisher()
    }
    public func getCategory() -> AnyPublisher<CategoryResponce,DifferentError> {
        return AF.request(Constants.apiEndpoint + "/stream/broadcastCategories", method: .get, encoding: JSONEncoding.default,interceptor: Interceptor(interceptors: [AuthInterceptor()]))
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .publishDecodable(type: CategoryResponce.self)
            .value()
            .mapError{ DifferentError.alamofire(wrapped: $0)}
            .eraseToAnyPublisher()
    }
 
    public func getCategoryId(id: Int) -> AnyPublisher<Datum,DifferentError> {
        return AF.request(Constants.apiEndpoint + "/stream/broadcastCategories/\(id)", method: .get, encoding: JSONEncoding.default,interceptor: Interceptor(interceptors: [AuthInterceptor()]))
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .publishDecodable(type: Datum.self)
            .value()
            .print("getBroadcastCategoryId")
            .mapError{ DifferentError.alamofire(wrapped: $0)}
            .eraseToAnyPublisher()
    }
    ///api/v0/stream/broadcastCategories/map
    public func getCategoryIdS(ids: [Int]) -> AnyPublisher<UploadMapCategores,DifferentError> {
        let parameters = [
            "ids": ids
        ]
        return AF.request(Constants.apiEndpoint + "/stream/broadcastCategories/map", method: .get,parameters: parameters, encoding: URLEncoding.default,interceptor: Interceptor(interceptors: [AuthInterceptor()]))
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .publishDecodable(type: UploadMapCategores.self)
            .value()
            .print("getBroadcastCategoryIdS")
            .mapError{ DifferentError.alamofire(wrapped: $0)}
            .eraseToAnyPublisher()
    }
    
    //MARK: - Get Broadcast Category//GET
    public func getBroadcastCategory(name: String) -> AnyPublisher<CategoryResponce, DifferentError> {
        return AF.request(Constants.apiEndpoint + "/stream/broadcastCategories?take=40&titleLike=\(name)", method:.get, parameters: [:])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .publishDecodable(type: CategoryResponce.self)
            .value()
            .print("getBroadcastCategory")
            .mapError{ DifferentError.alamofire(wrapped: $0)}
            .eraseToAnyPublisher()
    }
    //
    //MARK: - Start Stream//POST//AUTH
    public func startStream(stream:StartStream) -> AnyPublisher<StreamResponce, DifferentError> {
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
            .mapError{ DifferentError.alamofire(wrapped: $0)}
            .eraseToAnyPublisher()
    }
    //MARK: - Get List Users
    ///&fullNameLike=\(name)&sort=fullName
    ///&sort=fullName&searchLike=A
    public func getListUser(name: String) -> AnyPublisher<UserList,DifferentError> {
        return AF.request(Constants.apiEndpoint + "/user/users?take=100&sort=fullName&searchLike=\(name)", method: .get, encoding: JSONEncoding.default,interceptor: Interceptor(interceptors: [AuthInterceptor()]))
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .publishDecodable(type: UserList.self)
            .value()
            .mapError{ DifferentError.alamofire(wrapped: $0)}
            .eraseToAnyPublisher()
    }
    public func getListAllUser() -> AnyPublisher<UserList,DifferentError> {
        return AF.request(Constants.apiEndpoint + "/user/users?take=50&sort=fullName", method: .get, encoding: JSONEncoding.default,interceptor: Interceptor(interceptors: [AuthInterceptor()]))
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .publishDecodable(type: UserList.self)
            .value()
            .mapError{ DifferentError.alamofire(wrapped: $0)}
            .eraseToAnyPublisher()
    }
    public func getListReversUser(name: String) -> AnyPublisher<UserList,DifferentError> {
        return AF.request(Constants.apiEndpoint + "/user/users?take=100&sort=fullName&searchLike=\(name)", method: .get, encoding: JSONEncoding.default,interceptor: Interceptor(interceptors: [AuthInterceptor()]))
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .publishDecodable(type: UserList.self)
            .value()
            .mapError{ DifferentError.alamofire(wrapped: $0)}
            .eraseToAnyPublisher()
    }
    ///api/v0/stream/broadcastCategories/{id}/follow
    
    public func followCategory(id: Int) -> AnyPublisher<Category,DifferentError> {
        return AF.request(Constants.apiEndpoint + "/stream/broadcastCategories/\(id)/follow", method: .put, encoding: JSONEncoding.default,interceptor: Interceptor(interceptors: [AuthInterceptor()]))
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .publishDecodable(type: Category.self)
            .value()
            .mapError{ DifferentError.alamofire(wrapped: $0)}
            .eraseToAnyPublisher()
    
    }
    public func unFollowCategory(id: Int) -> AnyPublisher<Category,DifferentError> {
        return AF.request(Constants.apiEndpoint + "/stream/broadcastCategories/\(id)/follow", method: .delete, encoding: JSONEncoding.default,interceptor: Interceptor(interceptors: [AuthInterceptor()]))
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .publishDecodable(type: Category.self)
            .value()
            .mapError{ DifferentError.alamofire(wrapped: $0)}
            .eraseToAnyPublisher()
    
    }
    
}
