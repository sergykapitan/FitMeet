//
//  URLRequstBilder.swift
//  MakeStep
//
//  Created by novotorica on 20.07.2021.
//

import Foundation
import Alamofire

protocol URLRequstBilder: URLRequestConvertible {
    var baseUrl: String { get }
    var path: String { get }
    var headers: HTTPHeader? { get }
    var parameters: Parameters? { get }
    var metod: HTTPMethod { get }
}
extension URLRequstBilder {
    
    var baseUrl: String {
        return Constants.apiEndpoint + "/uploader/user"
    }
    func asURLRequest() throws -> URLRequest {
        let url = try baseUrl.asURL()
        var requst = URLRequest(url: url.appendingPathComponent(path))
        
        requst.httpMethod = metod.rawValue
        
        let boundaryConstant = "----------------12345";
        let contentType = "multipart/form-data;boundary=" + boundaryConstant
       
        
        requst.setValue(contentType, forHTTPHeaderField: "Content-Type")
        
        // create upload data to send
        let uploadData = NSMutableData()
        
        // add image
     uploadData.append("\r\n--\(boundaryConstant)\r\n".data(using: .utf8)!)
     uploadData.append("Content-Disposition: form-data; name=\"picture\"; filename=\"file.png\"\r\n".data(using: .utf8)!)
     uploadData.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
   ///  uploadData.append(imageData)
     uploadData.append("\r\n--\(boundaryConstant)--\r\n".data(using: .utf8)!)
        
        requst.httpBody = uploadData as Data
        
        switch metod {
        case .get:
            requst.httpBody = uploadData as Data
            requst = try URLEncoding.default.encode(requst, with: parameters)
        default:
            break
        }
        
        
        
        return requst
        
    }
}
enum CharacterProvider: URLRequstBilder {
    

        case showCharacter(limit: Int)
        
        
        var path: String {
            switch self {
            case .showCharacter:
                return "character"
            }
        }
        
        var headers: HTTPHeader? {
            switch self {
            default:
                return nil
            }
        }
        
        var parameters: Parameters? {
            switch self {
            case .showCharacter(let limit):
                return ["api_key":"FFFJBHCKWEHWVCJWEVCEWVCWEV",
                        "format" : "json",
                        "limit"  : String(describing: limit)]
        
            }
        }
        
        var metod: HTTPMethod {
            switch self {
            case .showCharacter:
                return .get
      
            }
        }
    }

enum Result<T: Codable> {
    case success(T)
    case failure(Error)
}
