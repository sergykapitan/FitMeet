//
//  UITraitEnvironment.swift
//  MakeStep
//
//  Created by Sergey on 07.04.2022.
//

import UIKit

extension UITraitEnvironment {
    
    //MARK: SafeArea
    
    private var window: UIWindow {
        return UIApplication.shared.windows[0]
    }
    
    private var safeFrame: CGRect {
        let safeFrame = window.safeAreaLayoutGuide.layoutFrame
       // var safeFrame =  window.rootViewController?.tabBarController?.tabBar.frame.size.height ?? 0
        return safeFrame
    }
    
    var safeAreaTopPadding: CGFloat {
        return UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0
       // return safeFrame.minY
    }
    
    var safeAreaBottomPadding: CGFloat {
       // return UIApplication.shared.keyWindow?..bottom ?? 0
        return window.frame.maxY - safeFrame.maxY
    }
    var safeAreaBottom: CGFloat {
        let bottomPadding = window.safeAreaInsets.bottom
        return bottomPadding
    }
}

