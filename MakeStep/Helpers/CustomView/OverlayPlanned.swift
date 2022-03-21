//
//  OverlayPlanned.swift
//  MakeStep
//
//  Created by Sergey on 21.03.2022.
//

import UIKit

final class OverlayPlanned : UIView {
    
    let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    var overlay : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.145, green: 0.145, blue: 0.145, alpha: 0.6)
        view.layer.borderWidth = 0.5
        view.layer.masksToBounds = false
        view.layer.borderColor = UIColor.gray.cgColor
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        return view
    }()
    var labelLive: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .white
        return label
    }()
    var imageLive: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "clock")
        return image
        
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
        addSubview(cardView)
        
    }
    private func initLayout() {
        cardView.fillSuperview()
        cardView.addSubview(overlay)
        overlay.anchor(top: cardView.topAnchor, left: cardView.leftAnchor, right: cardView.rightAnchor, bottom: cardView.bottomAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0)
        
        cardView.addSubview(imageLive)
        imageLive.anchor( left: overlay.leftAnchor, paddingLeft: 6, width: 12, height: 12)
        imageLive.centerY(inView: overlay)
        
        cardView.addSubview(labelLive)
        labelLive.anchor( left: imageLive.rightAnchor, paddingLeft: 6)
        labelLive.centerY(inView: overlay)               
    }
}

