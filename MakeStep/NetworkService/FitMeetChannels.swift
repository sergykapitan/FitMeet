//
//  FitMeetChannels.swift
//  FitMeet
//
//  Created by novotorica on 22.04.2021.
//

import Alamofire
import Combine

class FitMeetChannels {
    
    enum DifferentError: Error {
        case alamofire(wrapped: AFError)
        case malformedURL
    }
   
    //MARK: - create channel
    public func createChannel(channel: ChannelRequest) -> AnyPublisher<ChannelResponce, DifferentError> {
        return AF.request(Constants.apiEndpoint + "/channel/channels", method: .post, parameters: channel.asDictionary(), encoding: JSONEncoding.default,interceptor: Interceptor(interceptors: [AuthInterceptor()]))
                 .publishDecodable(type: ChannelResponce.self)
                 .value()
                 .mapError { DifferentError.alamofire(wrapped: $0) }
                 .eraseToAnyPublisher()
           }
    //MARK: - List Channels
    public func listChannels() -> AnyPublisher<ChannelModel, DifferentError> {
        return AF.request(Constants.apiEndpoint + "/channel/channels/my", method: .get,encoding: JSONEncoding.default,interceptor: Interceptor(interceptors: [AuthInterceptor()]))
                 .publishDecodable(type: ChannelModel.self)
                 .value()
                 .mapError { DifferentError.alamofire(wrapped: $0) }
                 .eraseToAnyPublisher()
           }
    public func listChannelsPrivate(idUser: Int) -> AnyPublisher<ChannelModel, DifferentError> {
        return AF.request(Constants.apiEndpoint + "/channel/channels/private?&sort=lastBroadcastDate&userId=\(idUser)", method: .get,encoding: JSONEncoding.default,interceptor: Interceptor(interceptors: [AuthInterceptor()]))
                 .validate(statusCode: 200..<300)
                 .validate(contentType: ["application/json"])
                 .publishDecodable(type: ChannelModel.self)
                 .value()
                 .mapError { DifferentError.alamofire(wrapped: $0) }
                 .eraseToAnyPublisher()
           }
    public func listChannelsNotAuth(idUser: Int) -> AnyPublisher<ChannelModel, DifferentError> {
        return AF.request(Constants.apiEndpoint + "/channel/channels?sort=lastBroadcastDate&userId=\(idUser)", method: .get, encoding: JSONEncoding.default)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .publishDecodable(type: ChannelModel.self)
            .value()
            .mapError{ DifferentError.alamofire(wrapped: $0)}
            .eraseToAnyPublisher()
    }
    public func listChannelsSubscribe(idUser: Int) -> AnyPublisher<ChannelModel, DifferentError> {
        return AF.request(Constants.apiEndpoint + "/channel/channels/private?&sort=id&userId=\(idUser)", method: .get,encoding: JSONEncoding.default,interceptor: Interceptor(interceptors: [AuthInterceptor()]))
                 .validate(statusCode: 200..<300)
                 .validate(contentType: ["application/json"])
                 .publishDecodable(type: ChannelModel.self)
                 .value()
                 .mapError { DifferentError.alamofire(wrapped: $0) }
                 .eraseToAnyPublisher()
           }
    
    //MARK: - MonetezationChannnel
    public func monnetChannels(id: Int,sub: NewSub) -> AnyPublisher<ChannelResponce, DifferentError> {
        return AF.request(Constants.apiEndpoint + "/channel/channels/\(id)/monetization", method: .post,parameters: sub.asDictionary(),encoding: JSONEncoding.default,interceptor: Interceptor(interceptors: [AuthInterceptor()]))
                 .validate(statusCode: 200..<300)
                 .validate(contentType: ["application/json"])
                 .publishDecodable(type: ChannelResponce.self)
                 .value()
                 .mapError { DifferentError.alamofire(wrapped: $0) }
                 .eraseToAnyPublisher()
           }
    public func delMonnetChannels(id: Int,tarifId: Int) -> AnyPublisher<ChannelResponce, DifferentError> {
        return AF.request(Constants.apiEndpoint + "/channel/channels/\(id)/monetization", method: .post,parameters: tarifId.asDictionary(),encoding: JSONEncoding.default,interceptor: Interceptor(interceptors: [AuthInterceptor()]))
                .validate(statusCode: 200..<300)
                .validate(contentType: ["application/json"])
                 .publishDecodable(type: ChannelResponce.self)
                 .value()
                 .mapError { DifferentError.alamofire(wrapped: $0) }
                 .eraseToAnyPublisher()
           }
    //MARK: - requestSecurityCode
    public func requestSecurityCode(phone:Phone) -> AnyPublisher< Bool, DifferentError> {
        return AF.request(Constants.apiEndpoint + "/sessions/phoneVerifyCode", method: .post, parameters: phone.asDictionary(), encoding: JSONEncoding.default, headers: nil)
                 .publishDecodable(type: Bool.self)
                 .value()
                 .mapError { DifferentError.alamofire(wrapped: $0) }
                 .eraseToAnyPublisher()
           }
    //MARK: - requestLogin
    public func requestLogin(phoneCode:PhoneCode) -> AnyPublisher<ResponceLogin, DifferentError> {
        return AF.request(Constants.apiEndpoint + "/sessions/loginPhone", method: .post, parameters: phoneCode.asDictionary(), encoding: JSONEncoding.default, headers: nil)
            .publishDecodable(type: ResponceLogin.self)
            .value()
            .mapError{ DifferentError.alamofire(wrapped: $0)}
            .eraseToAnyPublisher()
    }
    //MARK: - Change Password
    public func changePassword(password: Password) -> AnyPublisher<Bool, DifferentError> {
        return AF.request(Constants.apiEndpoint + "/sessions/password", method: .put, parameters: password.asDictionary(), encoding: JSONEncoding.default, headers: nil)
            .publishDecodable(type: Bool.self)
            .value()
            .mapError{ DifferentError.alamofire(wrapped: $0)}
            .eraseToAnyPublisher()
    }
    //MARK: - Follow Channels
    public func followChannels(id: Int) -> AnyPublisher<ChannelResponce, DifferentError> {
        return AF.request(Constants.apiEndpoint + "/channel/channels/\(id)/follow", method: .put, encoding: JSONEncoding.default, interceptor: Interceptor(interceptors: [AuthInterceptor()]))
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .publishDecodable(type: ChannelResponce.self)
            .value()
            .mapError{ DifferentError.alamofire(wrapped: $0)}
            .eraseToAnyPublisher()
    }
    
    public func unFollowChannels(id: Int) -> AnyPublisher<ChannelResponce, DifferentError> {
        return AF.request(Constants.apiEndpoint + "/channel/channels/\(id)/follow", method: .delete, encoding: JSONEncoding.default, interceptor: Interceptor(interceptors: [AuthInterceptor()]))
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .publishDecodable(type: ChannelResponce.self)
            .value()
            .mapError{ DifferentError.alamofire(wrapped: $0)}
            .eraseToAnyPublisher()
    }
    public func getChannelsUserName(username: String) -> AnyPublisher<ChannelResponce, DifferentError> {
        return AF.request(Constants.apiEndpoint + "/channel/channels/\(username)", method: .get, encoding: JSONEncoding.default)
            //.validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .publishDecodable(type: ChannelResponce.self)
            .value()
            .mapError{ DifferentError.alamofire(wrapped: $0)}
            .eraseToAnyPublisher()
    }
    
    public func getChannelsId(id: Int) -> AnyPublisher<ChannelResponce, DifferentError> {
        return AF.request(Constants.apiEndpoint + "/channel/channels/\(id)", method: .get, encoding: JSONEncoding.default)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .publishDecodable(type: ChannelResponce.self)
            .value()
            .mapError{ DifferentError.alamofire(wrapped: $0)}
            .eraseToAnyPublisher()
    }
    
    //MARK: - Change Channels
    public func changeChannels(id: Int,changeChannel: ChageChannel) -> AnyPublisher<ChannelResponce, DifferentError> {
        return AF.request(Constants.apiEndpoint + "/channel/channels/\(id)", method: .put,parameters: changeChannel.asDictionary(), encoding: JSONEncoding.default, interceptor: Interceptor(interceptors: [AuthInterceptor()]))
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .publishDecodable(type: ChannelResponce.self)
            .value()
            .mapError{ DifferentError.alamofire(wrapped: $0)}
            .eraseToAnyPublisher()
    }

}
