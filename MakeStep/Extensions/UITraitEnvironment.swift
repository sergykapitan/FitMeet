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
       // return UIApplication.shared.windows.first
    }
    
    private var safeFrame: CGRect {
        let safeFrame = window.safeAreaLayoutGuide.layoutFrame
        print("safeFrame == \(safeFrame)")
        return safeFrame
    }
    
    var safeAreaTopPadding: CGFloat {
        print("TopPadding == \(safeFrame.minY)")
        return safeFrame.minY
    }
    
    var safeAreaBottomPadding: CGFloat {
        print("safearea === \(window.frame.maxY - safeFrame.maxY)")
        var  i =  window.frame.maxY - safeFrame.maxY
        if i == 0.0 {
            return 34
        }
        return i //window.frame.maxY - safeFrame.maxY
    }

}

