//
//  Constant.swift
//  FitMeet
//
//  Created by novotorica on 14.04.2021.
//

import Foundation

class Constants {
    #if QA
    ///URL Address of testing api server
    static let apiEndpoint = "https://dev.makestep.com/api/v0"
    static let webViewPwa = "https://api.makestep.com/api/v0/legal/legals/html/"
    #elseif DEBUG
    ///URL Address of production api server
    static let apiEndpoint = "https://api.makestep.com/api/v0"
    static let webViewPwa = "https://api.makestep.com/api/v0/legal/legals/html/"
    #endif

    /// Citizen API User access token
    static let accessTokenKeyUserDefaults = "ActiveCitizenApiAccessToken"
    static let userID = "userID"
    static let chanellID = "chanellID"
    static let userFullName = "userFullName"
    static let broadcastID = "broadcastID"
    static let urlStream = "urlStream"
    static let defoultImage = "https://dev.makestep.com/api/v0/resizer?extension=jpeg&size=preview_m&path=%2Fqa-files%2Ffiles_95a4838f-6970-4728-afab-9d6a2345b943.jpeg"
    
    static let userNameKeyUserDefaults = "AuthorizedUserName"
    static let dateLastActivityUploadUserDefaults = "DateLastActivityUpload"
    static let hasUserEnteredQuizData = "HasUserEnteredQuizDataUserDefault"
    
}
