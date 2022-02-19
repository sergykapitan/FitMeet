//
//  DeeplinkHandlerProtocol.swift
//  MakeStep
//
//  Created by Sergey on 19.02.2022.
//

import Foundation

protocol DeeplinkHandlerProtocol {
    func canOpenURL(_ url: URL) -> Bool
    func openURL(_ url: URL)
}
