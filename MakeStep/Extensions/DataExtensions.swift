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
    
    func asDictionaryInt() -> [String: [String:[String]]]? {
       guard let data = try? JSONEncoder().encode(self) else { return nil }
       return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: [String:[String]]] }
     }
    func asDictionaryID() -> [String: [Int]]? {
       guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String:[ Int]] }
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
extension Data {

    /// Append string to Data
    ///
    /// Rather than littering my code with calls to `data(using: .utf8)` to convert `String` values to `Data`, this wraps it in a nice convenient little extension to Data. This defaults to converting using UTF-8.
    ///
    /// - parameter string:       The string to be added to the `Data`.

    mutating func append(_ string: String, using encoding: String.Encoding = .utf8) {
        if let data = string.data(using: encoding) {
            append(data)
        }
    }
}
extension Data
{
    func toString() -> String?
    {
        return String(data: self, encoding: .utf8)
    }
}
extension Array

{
//    func asDictionary() -> [String: Any]? {
//       guard let data = try? JSONEncoder().encode(self) else { return nil }
//       return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
//     }
}
extension Array {

    func dictionary<Key, Value>(withKey key: KeyPath<Element, Key>, value: KeyPath<Element, Value>) -> [Key: Value] {
        return reduce(into: [:]) { dictionary, element in
            let key = element[keyPath: key]
            let value = element[keyPath: value]
            dictionary[key] = value
        }
    }
}
