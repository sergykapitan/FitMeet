//
//  FitMeetChannels.swift
//  FitMeet
//
//  Created by novotorica on 22.04.2021.
//

import Alamofire
import Combine

class FitMeetChannels {
    
   // let token =

    enum DifferentError: Error {
        case alamofire(wrapped: AFError)
        case malformedURL
    }
   
    //MARK: - create channel
    public func createChannel(channel: ChannelRequest) -> AnyPublisher<ChannelResponce, DifferentError> {
        print(channel.asDictionary())
        return AF.request(Constants.apiEndpoint + "/channel/channels", method: .post, parameters: channel.asDictionary(), encoding: JSONEncoding.default,interceptor: Interceptor(interceptors: [AuthInterceptor()]))
                // .validate(statusCode: 200..<300)
                // .validate(contentType: ["application/json"])
                 .publishDecodable(type: ChannelResponce.self)
                 .value()
                 .print("createChannel")
                 .mapError { DifferentError.alamofire(wrapped: $0) }
                 .eraseToAnyPublisher()
           }
    //MARK: - List Channels
    public func listChannels() -> AnyPublisher<ChannelModel, DifferentError> {
        return AF.request(Constants.apiEndpoint + "/channel/channels/my", method: .get,encoding: JSONEncoding.default,interceptor: Interceptor(interceptors: [AuthInterceptor()]))
                 .publishDecodable(type: ChannelModel.self)
                 .value()
                 .print("listChannels")
                 .mapError { DifferentError.alamofire(wrapped: $0) }
                 .eraseToAnyPublisher()
           }

    //MARK: - requestSecurityCode
    public func requestSecurityCode(phone:Phone) -> AnyPublisher< Bool, DifferentError> {
        return AF.request(Constants.apiEndpoint + "/sessions/phoneVerifyCode", method: .post, parameters: phone.asDictionary(), encoding: JSONEncoding.default, headers: nil)
                 .publishDecodable(type: Bool.self)
                 .value()
                 .print("requestSecurityCode")
                 .mapError { DifferentError.alamofire(wrapped: $0) }
                 .eraseToAnyPublisher()
           }
    //MARK: - requestLogin
    public func requestLogin(phoneCode:PhoneCode) -> AnyPublisher<ResponceLogin, DifferentError> {
        return AF.request(Constants.apiEndpoint + "/sessions/loginPhone", method: .post, parameters: phoneCode.asDictionary(), encoding: JSONEncoding.default, headers: nil)
            .publishDecodable(type: ResponceLogin.self)
            .value()
            .print("requestLogin")
            .mapError{ DifferentError.alamofire(wrapped: $0)}
            .eraseToAnyPublisher()
    }
    //MARK: - Change Password
    public func changePassword(password: Password) -> AnyPublisher<Bool, DifferentError> {
        return AF.request(Constants.apiEndpoint + "/sessions/password", method: .put, parameters: password.asDictionary(), encoding: JSONEncoding.default, headers: nil)
            .publishDecodable(type: Bool.self)
            .value()
            .print("changePassword")
            .mapError{ DifferentError.alamofire(wrapped: $0)}
            .eraseToAnyPublisher()
    }
}
