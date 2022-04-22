//
//  DownSheetViewController.swift
//  MakeStep
//
//  Created by Sergey on 07.04.2022.
//

import UIKit

protocol DownSheetViewControllerDelegate: AnyObject {
    func downSheetItemTappedWith(_ controller : DownSheetViewController, type: DownSheetActionType, payload: Int?)
    func closeView()
}

class DownSheetViewController: UIViewController {
    
    lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleCloseAction))
        view.addGestureRecognizer(tapGesture)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
  
    lazy var shadowView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var gripView:  UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.854, green: 0.854, blue: 0.854, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel:  UILabel = {
        let label = UILabel()
        label.text = topTitle?.0 ?? ""
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = topTitle?.1 ?? .black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.register(DownSheetTableViewCell.self, forCellReuseIdentifier: "DownSheetTableViewCell")
        tv.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        tv.tableFooterView =  UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        tv.backgroundColor = .clear
        tv.isScrollEnabled = false
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    private lazy var dimmingView: UIView = {
        let blurEffect = UIBlurEffect(style: .systemMaterialDark)
        let view = UIVisualEffectView(effect: blurEffect)
        return view
    }()
    
    private var customView: UIView? = nil
    private var customViewHeight: CGFloat = 0
   
    private var defaultHeight: CGFloat = 300
    
    var containerViewHeightConstraint =  NSLayoutConstraint()
    var containerViewBottomConstraint =  NSLayoutConstraint()
    
    var items: [(DownSheetActionType, DownSheetActionStyle)]
    var topTitle: (String , UIColor)?
    var payload: Int?
    private let panGestureRecognizer = UIPanGestureRecognizer()
    weak var delegate: DownSheetViewControllerDelegate?
    var height: CGFloat = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        panGestureRecognizer.addTarget(self, action: #selector(handlePan))
        view?.addGestureRecognizer(panGestureRecognizer)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        var height: CGFloat = 0
        
        if let _ = customView {
            height = customViewHeight + safeAreaBottomPadding
        }else{
            height = tableView.contentSize.height + (12 * 2) + safeAreaBottomPadding
            if topTitle != nil {
                height = tableView.contentSize.height + 10 + 10 + titleLabel.frame.height + 32 + safeAreaBottomPadding
            }
        }
        animatePresentContainer(height)
        defaultHeight = height
    }
    @objc func handlePan(sender: UIPanGestureRecognizer) {
        animateDismissView(action: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        shadowView.layer.applyShadow(color: .black, alpha: 0.07, x: 0, y: -5, blur: 10, spread: 0)
        gripView.layer.cornerRadius = gripView.frame.height / 2
    }
    
    func setupView() {
        view.backgroundColor = .clear
    }
    
    func setupConstraints() {
        
        view.addSubview(backView)
        view.addSubview(shadowView)
        view.addSubview(containerView)
        view.addSubview(gripView)
        
        if let customView = customView {
            view.addSubview(customView)
        }else{
            if topTitle != nil {view.addSubview(titleLabel)}
            view.addSubview(tableView)
        }
        
        containerViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: defaultHeight)
        containerViewBottomConstraint = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: defaultHeight)
        
        NSLayoutConstraint.activate([
            
            backView.topAnchor.constraint(equalTo: view.topAnchor),
            backView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            shadowView.topAnchor.constraint(equalTo: containerView.topAnchor),
            shadowView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            shadowView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            shadowView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerViewHeightConstraint,
            containerViewBottomConstraint,
            
            gripView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),
            gripView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            gripView.widthAnchor.constraint(equalToConstant: 31),
            gripView.heightAnchor.constraint(equalToConstant: 4.13),
            
        ])
        
        if let customView = customView {
            customView.translatesAutoresizingMaskIntoConstraints = false
            customView.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleCloseAction))
            customView.addGestureRecognizer(tapGesture)
            
            NSLayoutConstraint.activate([
                customView.topAnchor.constraint(equalTo: gripView.bottomAnchor),
                customView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                customView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                customView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -safeAreaBottomPadding),
            ])
            return
        }
        
        if topTitle != nil {
            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(equalTo: gripView.bottomAnchor, constant: 10),
                titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
                titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
                tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
                tableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -5 - safeAreaBottomPadding),
            ])
        } else {
            NSLayoutConstraint.activate([
                tableView.topAnchor.constraint(equalTo: gripView.bottomAnchor, constant: 10),
                tableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -5 - safeAreaBottomPadding),
            ])
        }
        
    }
    
    @objc func handleCloseAction() {
        animateDismissView(action: nil)
    }
    
    func animatePresentContainer(_ height: CGFloat) {
        dimmingView.frame = backView.bounds
        dimmingView.alpha = 0
        backView.addSubview(dimmingView)

        UIView.animate(withDuration: 0.3) {
            self.dimmingView.alpha = 0.6
            self.containerViewBottomConstraint.constant = 0
            self.containerViewHeightConstraint.constant = height
            self.view.layoutIfNeeded()
        }
    }
    
    func animateContainerHeight(_ height: CGFloat) {
        UIView.animate(withDuration: 0.3) {
            self.containerViewHeightConstraint.constant = height
            self.view.layoutIfNeeded()
        }
    }
    
    func animateDismissView(action: (() -> Void)?) {
        
        UIView.animate(withDuration: 0.3) {
            self.containerViewBottomConstraint.constant = self.defaultHeight
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.delegate?.closeView()
            self.dismiss(animated: false) {
                action?()
            }
        }
    }
    
    init(items:[(DownSheetActionType, DownSheetActionStyle)], topTitle: (String , UIColor)? = nil, payload: Int? = nil) {
        self.topTitle = topTitle
        self.items = items
        self.payload = payload
        super.init(nibName: nil, bundle: nil)
    }
    
    init(customView: UIView, customViewHeight: CGFloat) {
        self.topTitle = nil
        self.items = []
        self.payload = nil
        self.customView = customView
        self.customViewHeight = customViewHeight
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension DownSheetViewController:  UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DownSheetTableViewCell", for: indexPath) as! DownSheetTableViewCell
        cell.setup(item: items[indexPath.row], index: indexPath.row)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
}

extension DownSheetViewController: DownSheetTableViewCellDelegate {
    
    func cellTappedWith(type: DownSheetActionType) {
        animateDismissView(action: { [weak self]  in
            guard let self = self else {return}
            self.delegate?.downSheetItemTappedWith(self, type: type, payload: self.payload)
        })
    }
    
}
