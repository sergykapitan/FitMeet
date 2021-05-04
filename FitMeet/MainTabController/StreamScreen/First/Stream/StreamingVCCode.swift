//
//  StreamingVCCode.swift
//  FitMeet
//
//  Created by novotorica on 19.04.2021.
//

import Foundation
import UIKit

final class StreamingVCCode: UIView {
    
    //MARK: - UI
    let capturePreviewView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        
        
        return view
    }()
    var tableView: UITableView = {
        let table = UITableView()
        return table
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
        addSubview(capturePreviewView)
 
    }
    private func initLayout() {
        
        capturePreviewView.fillSuperview()
        capturePreviewView.addSubview(tableView)
        tableView.fillSuperview()
         
    }
}
