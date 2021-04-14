//
//  FitMeetApi.swift
//  FitMeet
//
//  Created by novotorica on 14.04.2021.
//

import Alamofire
import Combine

class FitMeetApi {
    
    public func signupPasswordNew(authRequest: AuthorizationRequest) {
        
            AF.request(Constants.apiEndpoint, method: .post, parameters: authRequest.asDictionary(), encoding: JSONEncoding.default, headers: nil).validate(statusCode: 200 ..< 299).responseJSON { AFdata in
                do {
                    guard let jsonObject = try JSONSerialization.jsonObject(with: AFdata.data!) as? [String: Any] else {
                        print("Error: Cannot convert data to JSON object")
                        return
                    }
                    guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
                        print("Error: Cannot convert JSON object to Pretty JSON data")
                        return
                    }
                    guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                        print("Error: Could print JSON in String")
                        return
                    }
                    
                    print(prettyPrintedJson)
                } catch {
                    print("Error: Trying to convert JSON data to string")
                    return
                }
        }
    }

    public func signupPassword(authRequest: AuthorizationRequest) -> AnyPublisher<AuthResponce,AFError> {
        
       let publich = AF.request(Constants.apiEndpoint, method: .post, parameters: authRequest.asDictionary(), encoding: JSONEncoding.default, headers: nil).validate(statusCode: 200 ..< 299).responseJSON { AFdata in
            do {
                guard let jsonObject = try JSONSerialization.jsonObject(with: AFdata.data!) as? [String: Any] else {
                    print("Error: Cannot convert data to JSON object")
                    return
                }
                guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
                    print("Error: Cannot convert JSON object to Pretty JSON data")
                    return
                }
                guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                    print("Error: Could print JSON in String")
                    return
                }
                print(prettyPrintedJson)
            } catch {
                print("Error: Trying to convert JSON data to string")
                return
            }
        }
        .publishDecodable(type: AuthResponce.self) 
        return publich.value()
    }
    

    
    
    
    
    
    
    
    
    
    
}
