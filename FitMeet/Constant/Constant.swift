//
//  Constant.swift
//  FitMeet
//
//  Created by novotorica on 14.04.2021.
//

import Foundation

class Constants {
    #if DEBUG
    ///URL Address of testing api server
    static let apiEndpoint = "https://dev.fitliga.com/api/v0"
    #else
    ///URL Address of production api server
    static let apiEndpoint = "https://dev.fitliga.com/api/v0"
    #endif
    
    /// Citizen API User access token
    static let accessTokenKeyUserDefaults = "ActiveCitizenApiAccessToken"
    static let userID = "userID"
    static let chanellID = "chanellID"
    static let userFullName = "userFullName"
    static let broadcastID = "broadcastID"
    static let urlStream = "urlStream"
    
    static let userNameKeyUserDefaults = "AuthorizedUserName"
    static let dateLastActivityUploadUserDefaults = "DateLastActivityUpload"
    static let hasUserEnteredQuizData = "HasUserEnteredQuizDataUserDefault"
    
   // static let workoutRealmDatabaseSchemaVersion: UInt64 = 7
}
