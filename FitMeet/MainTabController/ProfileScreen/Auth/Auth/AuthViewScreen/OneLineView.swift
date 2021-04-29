//
//  OneLineView.swift
//  FitMeet
//
//  Created by novotorica on 13.04.2021.
//

import UIKit

final class OneLineView : UIView {
    
    let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    let lineleftView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hexString: "DADADA")
        return view
    }()
    let labelOR: UILabel = {
        let label = UILabel()
        label.text = "OR"
        label.font = UIFont.boldSystemFont(ofSize: 19)
        label.textColor = UIColor(hexString: "BBBCBC")
        return label
    }()
    let linerightView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hexString: "DADADA")
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
        addSubview(cardView)
        
    }
    private func initLayout() {
        cardView.fillSuperview()
        cardView.addSubview(labelOR)
        labelOR.centerX(inView: cardView)
        labelOR.anchor(top: cardView.topAnchor, bottom: cardView.bottomAnchor, paddingTop: 4, paddingBottom: 4)
        cardView.addSubview(lineleftView)
        lineleftView.anchor( left: cardView.leftAnchor, right: labelOR.leftAnchor, paddingLeft: 5, paddingRight: 5,   height: 1)
        lineleftView.centerY(inView: cardView)
        cardView.addSubview(linerightView)
        linerightView.anchor( left: labelOR.rightAnchor, right: cardView.rightAnchor, paddingLeft: 5, paddingRight: 5,   height: 1)
        linerightView.centerY(inView: cardView)
        
    }
    //MARK: - Methods
}
