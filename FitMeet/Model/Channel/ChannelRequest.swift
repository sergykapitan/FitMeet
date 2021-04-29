//
//  ChannelRequest.swift
//  FitMeet
//
//  Created by novotorica on 23.04.2021.
//

import Foundation

struct ChannelRequest:Codable {
        let name : String
        let title: String
        let description: String
        let backgroundUrl:String
        let facebookLink :String
        let instagramLink: String
        let twitterLink : String
    }
