//
//  MapWatcher.swift
//  MakeStep
//
//  Created by novotorica on 27.08.2021.
//

import Foundation


struct MapWatcher: Codable {
    let data: [String: Int]
    
}
struct MapChannel: Codable {
    let data: [Int: ChannelResponce]
    
}
