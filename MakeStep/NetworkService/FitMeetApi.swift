//
//  FitMeetApi.swift
//  FitMeet
//
//  Created by novotorica on 14.04.2021.
//

import Alamofire
import Combine
//import MVCServer.swift

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
    
    //MARK: - create token chat
    public func getTokenChat() -> AnyPublisher<TokenChat,DifferentError> {
        return AF.request(Constants.apiEndpoint + "/chat/chats/token", method: .get, encoding: JSONEncoding.default,interceptor: Interceptor(interceptors: [AuthInterceptor()]))
            .response(completionHandler: { ggg in
                print("GGGGG====\(ggg)")
            })
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .publishDecodable(type: TokenChat.self)
            .value()
            .print("TokenChat")
            .mapError{ DifferentError.alamofire(wrapped: $0)}
            .eraseToAnyPublisher()
    }
    public func getImageFile() -> AnyPublisher<UploadImage,DifferentError> {
        return AF.request(Constants.apiEndpoint + "/uploader/admin/file", method: .get, encoding: JSONEncoding.default,interceptor: Interceptor(interceptors: [AuthInterceptor()]))
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .publishDecodable(type: UploadImage.self)
            .value()
            .print("TokenChat")
            .mapError{ DifferentError.alamofire(wrapped: $0)}
            .eraseToAnyPublisher()
    }

    public func uploadImage(image: UIImage) -> AnyPublisher<UploadImage,DifferentError> {
        return AF.upload( multipartFormData: { multipartFormData in

            let data = image.jpegData(compressionQuality: 1.0)
            multipartFormData.append(data!, withName: "files",fileName: "\(Data()).png", mimeType: "image/png")

        }, to: Constants.apiEndpoint + "/uploader/user/azure", usingThreshold: UInt64.init(), method: .post ,interceptor: Interceptor(interceptors: [AuthInterceptor()]))
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .publishDecodable(type: UploadImage.self)
            .value()
            .print("uploadImage")
            .mapError{ DifferentError.alamofire(wrapped: $0)}
            .eraseToAnyPublisher()
        
    }
    public func getUserId(id: Int) -> AnyPublisher<User,DifferentError> {
        return AF.request(Constants.apiEndpoint + "/user/users/\(id)", method: .get, encoding: JSONEncoding.default,interceptor: Interceptor(interceptors: [AuthInterceptor()]))
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .publishDecodable(type: User.self)
            .value()
            .print("getUser")
            .mapError{ DifferentError.alamofire(wrapped: $0)}
            .eraseToAnyPublisher()
    }
    
    //
    public func getUserIdMap(ids: [Int]) -> AnyPublisher<UploadMapUser,DifferentError> {

        let parameters = [
            "ids": ids
        ]
        return AF.request(Constants.apiEndpoint + "/user/users/map", method: .get,parameters: parameters, encoding: URLEncoding.default, headers: nil,interceptor: Interceptor(interceptors: [AuthInterceptor()]))
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .publishDecodable(type: UploadMapUser.self)
            .value()
            .print("getUserMap")
            .mapError{ DifferentError.alamofire(wrapped: $0)}
            .eraseToAnyPublisher()
    }
///api/v0/watcher/watchers/map
    public func getWatcherMap(ids: [Int]) -> AnyPublisher<MapWatcher,DifferentError> {

        let parameters = [
            "ids": ids
        ]
        return AF.request(Constants.apiEndpoint + "/watcher/watchers/map", method: .get,parameters: parameters, encoding: URLEncoding.default, headers: nil,interceptor: Interceptor(interceptors: [AuthInterceptor()]))
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .publishDecodable(type: MapWatcher.self)
            .value()
            .print("getWatcherMap")
            .mapError{ DifferentError.alamofire(wrapped: $0)}
            .eraseToAnyPublisher()
    }
///api/v0/watcher/watchers/token токен для ватчера
    public func getTokenWatcher() -> AnyPublisher<TokenWatcher,DifferentError> {
        return AF.request(Constants.apiEndpoint + "/watcher/watchers/token", method: .get, encoding: JSONEncoding.default,interceptor: Interceptor(interceptors: [AuthInterceptor()]))
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .publishDecodable(type: TokenWatcher.self)
            .value()
            .print("getTokenWatcher")
            .mapError{ DifferentError.alamofire(wrapped: $0)}
            .eraseToAnyPublisher()
    }
}
