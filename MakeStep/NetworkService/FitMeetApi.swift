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
        case malformedURL(wrapped: ErrorMy)
        case error(error:String)
    }
    struct ErrorMy: Codable {
        let statusCode: Int?
        let message: String?
        let error: String?
    }
    //MARK: - signupPassword
    public func signupPassword(authRequest: AuthorizationRequest) -> AnyPublisher<ResponceLogin, DifferentError> {
        print(authRequest.asDictionary())
        return AF.request(Constants.apiEndpoint + "/auth/sessions/signupPassword", method: .post, parameters: authRequest.asDictionary() , encoding: JSONEncoding.default, headers: nil)
                // .validate(statusCode: 200..<300)
                 .validate(contentType: ["application/json"])
                 .publishDecodable(type: ResponceLogin.self)
                 .value()
                 .print("signupPassword")
                 .mapError{ DifferentError.alamofire(wrapped: $0)}
                 .eraseToAnyPublisher()
           }
    
    //MARK: - loginPassword
    public func loginPassword(login: LoginPassword) -> AnyPublisher<ResponcePassword, DifferentError> {
        print(login)
        return AF.request(Constants.apiEndpoint + "/auth/sessions/loginPassword", method: .post, parameters: login.asDictionary(), encoding: JSONEncoding.default,headers: nil)
                 .publishDecodable(type: ResponcePassword.self)
                 .value()
                 .print("loginPassword")
                 .mapError { DifferentError.alamofire(wrapped: $0) }
                 .eraseToAnyPublisher()
           }

    //MARK: - requestSecurityCode
    public func requestSecurityCode(phone:Phone) -> AnyPublisher< Bool, DifferentError> {
        return AF.request(Constants.apiEndpoint + "/auth/sessions/phoneVerifyCode", method: .post, parameters: phone.asDictionary(), encoding: JSONEncoding.default, headers: nil)
                 .publishDecodable(type: Bool.self)
                 .value()
                 .print("requestSecurityCode")
                 .mapError { DifferentError.alamofire(wrapped: $0) }
                 .eraseToAnyPublisher()
           }
    //MARK: - requestLogin
    public func requestLogin(phoneCode:PhoneCode) -> AnyPublisher<ResponceLogin, DifferentError> {
        return AF.request(Constants.apiEndpoint + "/auth/sessions/loginPhone", method: .post, parameters: phoneCode.asDictionary(), encoding: JSONEncoding.default, headers: nil)
            .publishDecodable(type: ResponceLogin.self)
            .value()
            .print("requestLogin")
            .mapError{ DifferentError.alamofire(wrapped: $0)}
            .eraseToAnyPublisher()
    }
    //MARK: - Change Password
    public func changePassword(password: Password) -> AnyPublisher<Bool, DifferentError> {
        return AF.request(Constants.apiEndpoint + "/auth/sessions/password", method: .put, parameters: password.asDictionary(), encoding: JSONEncoding.default, headers: nil)
            .publishDecodable(type: Bool.self)
            .value()
            .print("changePassword")
            .mapError{ DifferentError.alamofire(wrapped: $0)}
            .eraseToAnyPublisher()
    }
    ///api/v0/auth/sessions/signupApple
    //MARK: - SignWithApple
    public func signWithApple(token: AppleAuthorizationRequest) -> AnyPublisher<ResponceLogin, DifferentError> {
        return AF.request(Constants.apiEndpoint + "/auth/sessions/signupApple", method: .get, parameters: token.asDictionary(), encoding: URLEncoding.default, headers: nil)
                // .validate(statusCode: 200..<300)
                 .validate(contentType: ["application/json"])
                 .publishDecodable(type: ResponceLogin.self)
                 .value()
                 .print("signWithApple")
                 .mapError{ DifferentError.alamofire(wrapped: $0)}
                 .eraseToAnyPublisher()
           }
    
    public func getUser() -> AnyPublisher<User,DifferentError> {
        return AF.request(Constants.apiEndpoint + "/user/users/profile", method: .get, encoding: JSONEncoding.default,interceptor: Interceptor(interceptors: [AuthInterceptor()]))
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .publishDecodable(type: User.self)
            .value()
            .print("getUser")
            .mapError{ DifferentError.alamofire(wrapped: $0)}
            .eraseToAnyPublisher()
    }
    
    public func putUser(user: UserRequest) -> AnyPublisher<User,DifferentError> {
        return AF.request(Constants.apiEndpoint + "/user/users/profile", method: .put, parameters: user.asDictionary(), encoding: JSONEncoding.default,interceptor: Interceptor(interceptors: [AuthInterceptor()]))
           // .validate(statusCode: 200..<300)
           // .validate(contentType: ["application/json"])
            .publishDecodable(type: User.self)
            .value()
            .print("getUser")
            .mapError{ DifferentError.alamofire(wrapped: $0)}
            .eraseToAnyPublisher()
    }
}
