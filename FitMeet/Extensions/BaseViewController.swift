//
//  BaseViewController.swift
//  FitMeet
//
//  Created by novotorica on 24.06.2021.
//

import Foundation
import UIKit

class BaseScrollViewController: UIViewController {

lazy var contentViewSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + 100)
lazy var scrollView: UIScrollView = {
    let view = UIScrollView(frame: .zero)
    view.backgroundColor = .white
    view.frame = self.view.bounds
    view.contentSize = contentViewSize
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
}()
lazy var containerView: UIView = {
    let v = UIView()
    v.backgroundColor = .white
    v.frame.size = contentViewSize
    return v
}()

override func viewDidLoad() {
    view.backgroundColor = .white
    view.addSubview(scrollView)
    scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

    scrollView.addSubview(containerView)
    setupContainer(containerView)
    super.viewDidLoad()
    
}

public func setupContainer(_ container: UIView) {
    
}
}
