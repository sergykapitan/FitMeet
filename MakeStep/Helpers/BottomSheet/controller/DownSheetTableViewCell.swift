//
//  DownSheetTableViewCell.swift
//  MakeStep
//
//  Created by Sergey on 07.04.2022.
//

import UIKit

protocol DownSheetTableViewCellDelegate: AnyObject {
    func cellTappedWith(type: DownSheetActionType)
}

class DownSheetTableViewCell: UITableViewCell {
    
    private lazy var titleLabel:  UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var item: (DownSheetActionType, DownSheetActionStyle)? = nil {
        didSet{
            guard let item = item else {return}
            titleLabel.text = item.0.description
            titleLabel.textColor = item.1 == .regular ? .black : UIColor(red: 165.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        }
    }
    
    weak var delegate: DownSheetTableViewCellDelegate?
    
    func setup(item: (DownSheetActionType, DownSheetActionStyle), index: Int) {
        self.item = item
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.isUserInteractionEnabled = true
        backgroundColor = .white
        separatorInset = UIEdgeInsets(top: 0, left: UIScreen.main.bounds.width, bottom: 0, right: 0)
        selectionStyle = .none
        setupTapGesture()
        
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        ])
    }
    
    override func tapGestureSelector() {
        guard let item = item else {return}
        delegate?.cellTappedWith(type: item.0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


