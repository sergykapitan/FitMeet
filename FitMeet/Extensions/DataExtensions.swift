//
//  DataExtensions.swift
//  FitMeet
//
//  Created by novotorica on 14.04.2021.
//

import Foundation


public extension Encodable {
    func asDictionary() -> [String: Any]? {
       guard let data = try? JSONEncoder().encode(self) else { return nil }
       return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
     }
}
public extension Data {
    func decode<T>(type: T.Type)-> T where T: Codable {
        do {
            // Decode data to object
            let jsonDecoder = JSONDecoder()
            let object = try jsonDecoder.decode(T.self, from: self)
            return object
        }
        catch {
            print("That shouldn't have happened")
        }
        fatalError()}
}
