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
        
        if  UIApplication.shared.windows[0] != nil {
            print("HHHHHHHHHH === ")
            
        } else if let tab = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first {
            print("GGGGGGGGGG === ")
        }
        return UIApplication.shared.windows[0]
       // return UIApplication.shared.windows.first
    }
 
        
    private var safeFrame: CGRect {
        let safeFrame = window.safeAreaLayoutGuide.layoutFrame
        let ss = window.screen.bounds
        print("safeFrame == \(safeFrame)")
        print("ss == \(ss)")
        return safeFrame
    }
    
    var safeAreaTopPadding: CGFloat {
        print("TopPadding == \(safeFrame.minY)")
        return safeFrame.minY
    }
    
    var safeAreaBottomPadding: CGFloat {
        print("------- === \(window.frame.maxY - safeFrame.maxY)")
        var  i =  window.frame.maxY - safeFrame.maxY
        if i == 0.0 {
            return 34
        }
        return i //window.frame.maxY - safeFrame.maxY
    }

}

