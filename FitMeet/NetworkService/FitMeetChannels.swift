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
    //api/v0/channel/channels
//    {
//      "name": "string",
//      "title": "string",
//      "description": "string",
//      "backgroundUrl": "https://static.fitliga.com/jyyRD5yf2tuv",
//      "facebookLink": "https://facebook.com/jyyRD5yf2tuv",
//      "instagramLink": "https://instagram.com/jyyRD5yf2tuv",
//      "twitterLink": "https://twitter.com/jyyRD5yf2tuv"
//    }
    //MARK: - create channel
    public func createChannel(authRequest: AuthorizationRequest) -> AnyPublisher<ResponceLogin, DifferentError> {
        return AF.request(Constants.apiEndpoint + "channel/channels", method: .post, parameters: authRequest.asDictionary(), encoding: JSONEncoding.default, headers: nil)
                 .publishDecodable(type: ResponceLogin.self)
                 .value()
                 .print("createChannel")
                 .mapError { DifferentError.alamofire(wrapped: $0) }
                 .eraseToAnyPublisher()
           }
    
    
    
    //api/v0/channel/channels
    //order string ASC
    //page   integer  Default value : 1
    //take   integer  Default value : 10
   // sort   string  Available values : id, name, userId, subscribersCount, followersCount, status, lastBroadcastDate
    //status [String] BANNED, ACTIVE
    // titleLike string
    //MARK: - List Channels
    public func listChannels(login: LoginPassword) -> AnyPublisher<ResponceLogin, DifferentError> {
        return AF.request(Constants.apiEndpoint + "channel/channels", method: .post, parameters: login.asDictionary(), encoding: JSONEncoding.default, headers: nil)
                 .publishDecodable(type: ResponceLogin.self)
                 .value()
                 .print("loginPassword")
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
