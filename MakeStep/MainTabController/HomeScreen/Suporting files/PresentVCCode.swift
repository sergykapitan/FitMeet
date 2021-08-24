//
//  PresentVCCode.swift
//  MakeStep
//
//  Created by novotorica on 09.07.2021.
//

import UIKit
import Foundation

import HHCustomCorner
import Kingfisher

final class PresentVCCode: UIView {

    //MARK: - First layer in TopView
    
    let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hexString: "#F6F6F6")
       // view.clipsToBounds = true
            return view
        }()
   
    //MARK: - initial
    init() {
        super.init(frame: CGRect.zero)
        initUI()
        createCardViewLayer()
        
    }
    
    //MARK: - constraint First Layer
    private func initUI() {
        
        addSubview(cardView)
       
    }
    func createCardViewLayer() {

        cardView.fillFull(for: self)

    }
    func setImage(image:String,imagepromo: String) {
      
    }
    func setLabel(description: String,category: String) {
      
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

