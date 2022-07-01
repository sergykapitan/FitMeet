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
        return AF.request(Constants.apiEndpoint + "/auth/sessions/signupPassword", method: .post, parameters: authRequest.asDictionary() , encoding: JSONEncoding.default, headers: nil)
                 .publishDecodable(type: ResponceLogin.self)
                 .value()
                 .mapError{ DifferentError.alamofire(wrapped: $0)}
                 .eraseToAnyPublisher()
           }
    
    //MARK: - loginPassword
    public func loginPassword(login: LoginPassword) -> AnyPublisher<ResponcePassword, DifferentError> {
        print(login)
        return AF.request(Constants.apiEndpoint + "/auth/sessions/loginPassword", method: .post, parameters: login.asDictionary(), encoding: JSONEncoding.default,headers: nil)
                 .publishDecodable(type: ResponcePassword.self)
                 .value()
                 .mapError { DifferentError.alamofire(wrapped: $0) }
                 .eraseToAnyPublisher()
           }
    public func codeReview(hashs: Hashs,code: String) -> AnyPublisher<Hashs, DifferentError> {
        return AF.request(Constants.apiEndpoint + "/auth/sessions/codeReview/\(code)", method: .post, parameters: hashs.asDictionary(), encoding: JSONEncoding.default)
                 .publishDecodable(type: Hashs.self)
                 .value()
                 .mapError { DifferentError.alamofire(wrapped: $0) }
                 .eraseToAnyPublisher()
           }

    //MARK: - requestSecurityCode
    public func requestSecurityCode(phone:Phone) -> AnyPublisher< Bool, DifferentError> {
        return AF.request(Constants.apiEndpoint + "/auth/sessions/phoneVerifyCode", method: .post, parameters: phone.asDictionary(), encoding: JSONEncoding.default, headers: nil)
                 .publishDecodable(type: Bool.self)
                 .value()
                 .mapError { DifferentError.alamofire(wrapped: $0) }
                 .eraseToAnyPublisher()
           }
    // api/v0/auth/sessions/passwordResetSms
    public func resetPassword(phone:Phone) -> AnyPublisher< ResetPassword, DifferentError> {
        return AF.request(Constants.apiEndpoint + "/auth/sessions/passwordResetSms", method: .post, parameters: phone.asDictionary(), encoding: JSONEncoding.default, headers: nil)
                 .publishDecodable(type: ResetPassword.self)
                 .value()
                 .mapError { DifferentError.alamofire(wrapped: $0) }
                 .eraseToAnyPublisher()
           }
    // api/v0/auth/sessions/password/sms/{code}
    public func resetOldPassword(code:String,resetOld:ResetOldPassword) -> AnyPublisher< Bool, DifferentError> {
        return AF.request(Constants.apiEndpoint + "/auth/sessions/password/sms/\(code)", method: .put, parameters: resetOld.asDictionary(), encoding: JSONEncoding.default, headers: nil)
                 .publishDecodable(type: Bool.self)
                 .value()
                 .mapError { DifferentError.alamofire(wrapped: $0) }
                 .eraseToAnyPublisher()
           }
    public func resetPasswordSms(reset:ResetPasswordSms) -> AnyPublisher< Bool, DifferentError> {
        return AF.request(Constants.apiEndpoint + "/auth/sessions/changePasswordBySms", method: .put, parameters: reset.asDictionary(), encoding: JSONEncoding.default, headers: nil)
                 .publishDecodable(type: Bool.self)
                 .value()
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
            .mapError{ DifferentError.alamofire(wrapped: $0)}
            .eraseToAnyPublisher()
    }
    ///api/v0/auth/sessions/signupApple
    //MARK: - SignWithApple
    public func signWithApple(token: AppleAuthorizationRequest) -> AnyPublisher<ResponceLogin, DifferentError> {
        return AF.request(Constants.apiEndpoint + "/auth/sessions/signupApple", method: .get, parameters: token.asDictionary(), encoding: URLEncoding.default, headers: nil)
                .validate(statusCode: 200..<300)
                .validate(contentType: ["application/json"])
                .publishDecodable(type: ResponceLogin.self)
                .value()
                .mapError{ DifferentError.alamofire(wrapped: $0)}
                .eraseToAnyPublisher()
           }
    
    public func getUser() -> AnyPublisher<User,DifferentError> {
        return AF.request(Constants.apiEndpoint + "/user/users/profile", method: .get, encoding: JSONEncoding.default,interceptor: Interceptor(interceptors: [AuthInterceptor()]))
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .publishDecodable(type: User.self)
            .value()
            .mapError{ DifferentError.alamofire(wrapped: $0)}
            .eraseToAnyPublisher()
    }
    
    public func putUser(user: UserRequest) -> AnyPublisher<User,DifferentError> {
        return AF.request(Constants.apiEndpoint + "/user/users/profile", method: .put, parameters: user.asDictionary(), encoding: JSONEncoding.default,interceptor: Interceptor(interceptors: [AuthInterceptor()]))
            //.validate(statusCode: 200..<300)
            //.validate(contentType: ["application/json"])
            .publishDecodable(type: User.self)
            .value()
            .mapError{ DifferentError.alamofire(wrapped: $0)}
            .eraseToAnyPublisher()
    }
    
    //MARK: - create token chat
    public func getTokenChat() -> AnyPublisher<TokenChat,DifferentError> {
        return AF.request(Constants.apiEndpoint + "/chat/chats/token", method: .get, encoding: JSONEncoding.default,interceptor: Interceptor(interceptors: [AuthInterceptor()]))
            .response(completionHandler: { ggg in
                print("getToken Chat == \(ggg)")
            })
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .publishDecodable(type: TokenChat.self)
            .value()
            .mapError{ DifferentError.alamofire(wrapped: $0)}
            .eraseToAnyPublisher()
    }
    public func getImageFile() -> AnyPublisher<UploadImage,DifferentError> {
        return AF.request(Constants.apiEndpoint + "/uploader/admin/file", method: .get, encoding: JSONEncoding.default,interceptor: Interceptor(interceptors: [AuthInterceptor()]))
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .publishDecodable(type: UploadImage.self)
            .value()
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
            .mapError{ DifferentError.alamofire(wrapped: $0)}
            .eraseToAnyPublisher()
        
    }
    //,params: [String: Any]
    public func uploadVideo(image: Data,channelId: String,preview: String ,title: String, description: String, categoryId: [Int]) -> AnyPublisher<ResponseVOD,DifferentError> {
 

        return AF.upload( multipartFormData: { multipartFormData in

            multipartFormData.append( image, withName: "file",fileName: "\(Data()).mp4", mimeType: "video/mp4")
            let stringifiedNumberList = categoryId
                    .map { String($0) }
                    .joined(separator: ", ")
                           multipartFormData.append(channelId.data(using: .utf8, allowLossyConversion: false)!, withName: "channelId")
                           multipartFormData.append(stringifiedNumberList.data(using: .utf8, allowLossyConversion: false)!, withName: "categoryIds")
                           multipartFormData.append(preview.data(using: .utf8, allowLossyConversion: false)! , withName: "previewPath")
                           multipartFormData.append(title.data(using: .utf8, allowLossyConversion: false)!, withName: "title")
                           multipartFormData.append(description.data(using: .utf8, allowLossyConversion: false)!, withName: "description")
                         //  multipartFormData.append("false".data(using: .utf8, allowLossyConversion: false)!, withName: "onlyForSubscribers")
                        //   multipartFormData.append("".data(using: .utf8, allowLossyConversion: false)!, withName: "appProductId")


        },to: Constants.apiEndpoint + "/vodUpload/userUpload",usingThreshold: UInt64.init(),  method: .post, interceptor: Interceptor(interceptors: [AuthInterceptor()]))
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .publishDecodable(type: ResponseVOD.self)
            .value()
            .print("uploadVideo")
            .mapError{ DifferentError.alamofire(wrapped: $0)}
            .eraseToAnyPublisher()
        
    }
    public func getUserId(id: Int) -> AnyPublisher<User,DifferentError> {
        return AF.request(Constants.apiEndpoint + "/user/users/\(id)", method: .get, encoding: JSONEncoding.default,interceptor: Interceptor(interceptors: [AuthInterceptor()]))
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .publishDecodable(type: User.self)
            .value()
            .mapError{ DifferentError.alamofire(wrapped: $0)}
            .eraseToAnyPublisher()
    }
   
    public func incrementViewersCount(id: Int) -> AnyPublisher<Bool,DifferentError> {
        return AF.request(Constants.apiEndpoint + "/stream/broadcasts/incrementViewersCount/\(id)", method: .put)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["text/html"])
            .publishDecodable(type: Bool.self)
            .value()
            .print("ViewersCount")
            .mapError{ DifferentError.alamofire(wrapped: $0)}
            .eraseToAnyPublisher()
    }
    
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

    public func getWatcherMap(ids: [Int]) -> AnyPublisher<MapWatcher,DifferentError> {

        let parameters = [
            "ids": ids
        ]
        return AF.request(Constants.apiEndpoint + "/watcher/watchers/map", method: .get,parameters: parameters, encoding: URLEncoding.default, headers: nil,interceptor: Interceptor(interceptors: [AuthInterceptor()]))
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .publishDecodable(type: MapWatcher.self)
            .value()
            .mapError{ DifferentError.alamofire(wrapped: $0)}
            .eraseToAnyPublisher()
    }
    public func getChannelMap(ids: [Int]) -> AnyPublisher<MapChannel,DifferentError> {

        let parameters = [
            "ids": ids
        ]
        // private
        return AF.request(Constants.apiEndpoint + "/channel/channels/map", method: .get,parameters: parameters, encoding: URLEncoding.default, headers: nil,interceptor: Interceptor(interceptors: [AuthInterceptor()]))
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .publishDecodable(type: MapChannel.self)
            .value()
            .print("getChannel")
            .mapError{ DifferentError.alamofire(wrapped: $0)}
            .eraseToAnyPublisher()
    }
 
    public func getTokenWatcher() -> AnyPublisher<TokenWatcher,DifferentError> {
        return AF.request(Constants.apiEndpoint + "/watcher/watchers/token", method: .get, encoding: JSONEncoding.default,interceptor: Interceptor(interceptors: [AuthInterceptor()]))
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .publishDecodable(type: TokenWatcher.self)
            .value()
            .mapError{ DifferentError.alamofire(wrapped: $0)}
            .eraseToAnyPublisher()
    }
    // MARK: - Apple
 
    public func getAppProduct() -> AnyPublisher<AppleProduct,DifferentError> {
        return AF.request(Constants.apiEndpoint + "/appPurchase/appleProducts", method: .get, encoding: JSONEncoding.default,interceptor: Interceptor(interceptors: [AuthInterceptor()]))
            .response(completionHandler: { ggg in print("GGGGG====\(ggg)")   })
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .publishDecodable(type: AppleProduct.self)
            .value()
            .mapError{ DifferentError.alamofire(wrapped: $0)}
            .eraseToAnyPublisher()
    }
 
    // MARK: - Subscribe
    public func subscribeApp(id:String,product:ValidateProduct) -> AnyPublisher< ProducctResponce, DifferentError> {
        return AF.request(Constants.apiEndpoint + "/stripe/applePurchases/channels/\(id)", method: .post,parameters: product.asDictionary(), encoding: JSONEncoding.default, interceptor: Interceptor(interceptors: [AuthInterceptor()]))
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .publishDecodable(type: ProducctResponce.self)
            .value()
            .print("AppPurchase")
            .mapError{ DifferentError.alamofire(wrapped: $0)}
            .eraseToAnyPublisher()
    }
}
