//
//  ChatVCCode.swift
//  MakeStep
//
//  Created by novotorica on 08.07.2021.
//

import UIKit
import Kingfisher

final class ChatVCCode: UIView {

    //MARK: - First layer in TopView
    
    let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        }()
    var tableView: UITableView = {
        let table = UITableView()
        return table
    }()
    var buttonChat: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "Back1-2"), for: .normal)
        return button
    }()
    var textView: UITextView = {
        let text = UITextView()
        text.layer.borderColor = UIColor(hexString: "DADADA").cgColor
        text.backgroundColor = UIColor(hexString: "#F6F6F6")
        text.textColor = .lightGray
       
        return text
    }()
    var sendMessage: UIButton = {
        var button = UIButton()
        button.setBackgroundImage(#imageLiteral(resourceName: "Frame"), for: .normal)
        button.layer.shadowOffset = CGSize(width: 10, height: 10)
        button.layer.shadowOpacity = 0.8
        button.layer.shadowRadius = 5
        button.layer.shouldRasterize = true
        button.layer.rasterizationScale = UIScreen.main.scale
        button.layer.shadowColor = UIColor(hexString: "#D8D8D8").cgColor
        return button
    }()
    var View: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.shadowOffset = CGSize(width: 10,
                                          height: 10)
        view.layer.shadowColor = UIColor(hexString: "#D8D8D8").cgColor
        view.layer.shadowRadius = 5
        view.layer.shadowOpacity = 0.8
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = UIScreen.main.scale
        view.layer.cornerRadius = 20
        return view
    }()
   

 //MARK: - initial
    override init(frame: CGRect) {
        super.init(frame: frame)
        createCardViewLayer()
    }
    
 //MARK: - constraint First Layer
    func createCardViewLayer() {
        addSubview(cardView)
        cardView.fillSuperview()

        cardView.addSubview(buttonChat)
        buttonChat.anchor(top: cardView.topAnchor, paddingTop: 10,width: 12,height: 12)
        buttonChat.centerX(inView: cardView)
        
        cardView.addSubview(sendMessage)
       // sendMessage.anchor(right: cardView.rightAnchor,bottom: cardView.bottomAnchor,paddingRight: 2, paddingBottom: 18,width: 64 ,height: 60)
        
        cardView.addSubview(View)
        View.anchor( left: cardView.leftAnchor, right: sendMessage.leftAnchor, bottom: cardView.bottomAnchor, paddingLeft: 20, paddingRight: 0, paddingBottom: 30, height: 18)
        
        cardView.addSubview(tableView)
        tableView.anchor(top: buttonChat.bottomAnchor, left: cardView.leftAnchor, right: cardView.rightAnchor, bottom: sendMessage.topAnchor, paddingTop: 10, paddingLeft: 0, paddingRight: 0, paddingBottom: 0)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

