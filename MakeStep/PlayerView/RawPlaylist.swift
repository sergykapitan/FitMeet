//
//  RawPlaylist.swift
//  MakeStep
//
//  Created by Sergey on 01.04.2022.
//

import Foundation
import UIKit
struct RawPlaylist {
    let url: URL
    let content: String
}
struct Channel {
    let title: String
    var url: URL?
}
struct StreamResolution {
     let maxBandwidth: Double
     let averageBandwidth: Double
     let resolution: CGSize
     let stringHeight: String
}
