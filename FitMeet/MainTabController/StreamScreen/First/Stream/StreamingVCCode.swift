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
       // view.clipsToBounds = true
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
//    init() {
//    super.init(nibName: nil, bundle: nil)
//                 initUI()
//                initLayout()
//
//            //Do whatever you want here
//        }
    
    required init?(coder: NSCoder) {

        fatalError("init(coder:) has not been implemented")
    }
//    required init?(coder aDecoder: NSCoder) {
//            super.init(coder: aDecoder)
//
//        }
    private func initUI() {
        addSubview(capturePreviewView)
 
    }
    private func initLayout() {
        
        capturePreviewView.fillSuperview()
     //   capturePreviewView.fillFull(for: self)
//        capturePreviewView.anchor(top: superview?.safeAreaLayoutGuide.topAnchor, left: superview?.safeAreaLayoutGuide.leftAnchor, right: superview?.safeAreaLayoutGuide.rightAnchor, bottom: superview?.safeAreaLayoutGuide.bottomAnchor, paddingTop: 160, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: 0)
        capturePreviewView.addSubview(tableView)
        tableView.anchor(top: capturePreviewView.topAnchor,
                         left: capturePreviewView.leftAnchor,
                         right: capturePreviewView.rightAnchor,
                         bottom: capturePreviewView.bottomAnchor,
                         paddingTop: 0, paddingLeft: 10, paddingRight: 10, paddingBottom: 0)
         
    }
}
