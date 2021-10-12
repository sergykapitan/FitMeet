//
//  DeleteStreamCode.swift
//  MakeStep
//
//  Created by novotorica on 01.10.2021.
//

import Foundation
import UIKit


final class DeleteStreamCode: UIView {
    
    //MARK: - UI
    let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
  
    
    // MARK: - Init
    init() {
        super.init(frame: CGRect.zero)
        initUI()
        initLayout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func initUI() {
       
 
    }
    private func initLayout() {
       
        
    }
}
