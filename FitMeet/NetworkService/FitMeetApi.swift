//
//  FitMeetApi.swift
//  FitMeet
//
//  Created by novotorica on 14.04.2021.
//

import Alamofire
import Combine

class FitMeetApi {
 
    enum DifferentError: Error {
        case alamofire(wrapped: AFError)
        case malformedURL
    }
    //MARK: - signupPassword
    public func signupPassword(authRequest: AuthorizationRequest) -> AnyPublisher<ResponceLogin, DifferentError> {
        print(authRequest)
        return AF.request(Constants.apiEndpoint + "/sessions/signupPassword", method: .post, parameters: authRequest.asDictionary(), encoding: JSONEncoding.default, headers: nil)
                 .publishDecodable(type: ResponceLogin.self)
                 .value()
                 .print("signupPassword")
                 .mapError { DifferentError.alamofire(wrapped: $0) }
                 .eraseToAnyPublisher()
           }
    
    //MARK: - loginPassword
    public func loginPassword(login: LoginPassword) -> AnyPublisher<ResponceLogin, DifferentError> {
        return AF.request(Constants.apiEndpoint + "/sessions/loginPassword", method: .post, parameters: login.asDictionary(), encoding: JSONEncoding.default, headers: nil)
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
