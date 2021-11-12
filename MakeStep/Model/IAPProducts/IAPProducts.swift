//
//  INAPProducts.swift
//  MakeStep
//
//  Created by Sergey on 02.11.2021.
//

import Foundation

enum IAPProducts: String {
#if QA
     case consumable = "com.makestep.consumable.qa"
#elseif DEBUG
     case consumable = "com.makestep.consumable"
#endif
    
   // case nonRenewable = "month_subscription"
   // case autoMonthSubscription = "com.makestep.month.auto"
}
