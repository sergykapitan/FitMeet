//
//  DownSheetActionType.swift
//  MakeStep
//
//  Created by Sergey on 07.04.2022.
//
protocol DownSheetActionType {
    var description: String { get }
}

enum DownSheetActionStyle {
    case regular, destructive
}

enum ArtworkItemActionType: DownSheetActionType {
    
    case share, copyLink,makePrivate,  delete, edit, sendComplaint, block
    
    var description : String {
        switch self {
        case .share: return "Share with..."
        case .copyLink: return "Copy link"
        case .makePrivate: return "Make it private for..."
        case .delete: return "Delete"
        case .edit: return "Edit"
        case .sendComplaint: return "Send a complaint..."
        case .block: return "Block a user"
        }
    }
}

enum LinkCopiedActionType: DownSheetActionType {
    
    case copied
    
    var description : String {
        switch self {
        case .copied: return "Link copied"
        }
    }
}

enum BlockUserActionType: DownSheetActionType {
    
    case block, notBlock
    
    var description : String {
        switch self {
        case .block: return "Yes, block the user"
        case .notBlock: return "No, don't block the user"
        }
    }
}

enum DeleteItemActionType: DownSheetActionType {
    
    case delete, notDelete
    
    var description : String {
        switch self {
        case .delete: return "Yes, delete the broadcast"
        case .notDelete: return "No, don't delete the broadcast"
        }
    }
}
enum DeleteAccountType: DownSheetActionType {
    
    case delete, notDelete
    
    var description : String {
        switch self {
        case .delete: return "Yes, delete the account"
        case .notDelete: return "No, don't delete the account"
        }
    }
}

enum BlockUserSendComplaint: DownSheetActionType {
    
    case block, notBlock
    
    var description : String {
        switch self {
        case .block: return "Yes, block the user"
        case .notBlock: return "No, don't block the user"
        }
    }
}

enum ArtworkSendComplaint: DownSheetActionType {
    
    case spam, inappropriateContent , other
    
    var description : String {
        switch self {
        case .spam: return "This is spam"
        case .inappropriateContent: return "This is inappropriate content"
        case .other: return "Other..."
        }
    }
}

enum ArtworkSendOtherComplaint: DownSheetActionType {
    
    case nudity, hostileLanguage, violence, saleIllegal, bullyingOrStalking, violationRights, suicide, fraud, fake, dontLike
    
    var description : String {
        switch self {
        case .nudity: return "Nudity or sexual activity"
        case .hostileLanguage: return "Hostile language or symbols"
        case .violence: return "Violence or dangerous organizations"
        case .saleIllegal: return "Sale of illegal or legally regulated goods"
        case .bullyingOrStalking: return "Bullying or stalking"
        case .violationRights: return "Violation of intellectual property rights"
        case .suicide: return "Suicide, self-mutilation, or eating disorders"
        case .fraud: return "Fraud or deception"
        case .fake: return "Fake information"
        case .dontLike: return "I do not like this"
        }
    }
}



enum CollectionActionType: DownSheetActionType {
    
    case share, copyLink, makePrivate, delete, edit, sendComplaint, block
    
    var description : String {
        switch self {
        case .share: return "Share with..."
        case .copyLink: return "Copy link"
        case .makePrivate: return "Make it private for..."
        case .delete: return "Delete"
        case .edit: return "Edit"
        case .sendComplaint: return "Send a complaint..."
        case .block: return "Block a user"
        }
    }
}

enum FollowersActionType: DownSheetActionType {
    
    case delete, follow, unfollow
    
    var description : String {
        switch self {
        case .delete: return "Delete"
        case .follow: return "Follow"
        case .unfollow: return "Unfollow"
        }
    }
}

enum DeleteProfileActionType: DownSheetActionType {
    
    case delete, no
    
    var description : String {
        switch self {
        case .delete: return "Yes, delete the account"
        case .no: return "No, don't delete the account"
        }
    }
}

enum BurgerActionType: DownSheetActionType {
    
    case termsOfService, privacyNotice, logOut
    
    var description : String {
        switch self {
        case .termsOfService: return "Terms of service"
        case .privacyNotice: return "Privacy notice"
        case .logOut: return "Log out"
        }
    }
}


