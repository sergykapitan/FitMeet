//
//  ServiceProvider.swift
//  MakeStep
//
//  Created by novotorica on 20.07.2021.
//

import Foundation
import Alamofire
class Serviceprovider<T: URLRequstBilder> {
    
    func loadView<U : Codable>(service: T,decodeType: U.Type,complecion: @escaping(Result<U>) -> Void) {
        guard let urlRequst = service.urlRequest else { return }
        AF.request(urlRequst).responseDecodable(of: U.self) { ( responce )in
            switch responce.result {
            case .success(let result):
            complecion(.success(result))
            case .failure(let error):
            complecion(.failure(error))
            }
        }
      }
}
