//
//  Preference.swift
//  FitMeet
//
//  Created by novotorica on 23.04.2021.
//

import Foundation
struct Preference {
    static var defaultInstance = Preference()
//rtmp://vp-push-cloud-ed.gvideo.co/in/68628?551f45c93b0d12adc6c471d27ddc4753
    //UserDefaults.standard.string(forKey: Constants.urlStream)
    var uri: String? = UserDefaults.standard.string(forKey: Constants.urlStream)
    var streamName: String? = "68628?551f45c93b0d12adc6c471d27ddc4753"
}
