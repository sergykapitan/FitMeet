//
//  ChatVCPlayerCode.swift
//  MakeStep
//
//  Created by novotorica on 26.07.2021.
//

import UIKit
import Kingfisher

final class ChatVCPlayerCode: UIView {

    //MARK: - First layer in TopView
    
    let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 0.8
        view.layer.borderColor = .init(red: 0, green: 0, blue: 0, alpha: 0)
        return view
        }()
    var tableView: UITableView = {
        let table = UITableView()
        return table
    }()
    var buttonChat: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "dismiss"), for: .normal)
        button.tintColor = .black
       // button.backgroundColor = .blue
        return button
    }()
    var textView: UITextView = {
        let text = UITextView()
        text.layer.cornerRadius = 20
        text.layer.borderWidth = 1
        text.layer.borderColor = UIColor(hexString: "DADADA").cgColor
        text.backgroundColor = UIColor(hexString: "#F6F6F6")
        text.textColor = .lightGray
        text.font = UIFont.systemFont(ofSize: 25)
        return text
    }()
    var sendMessage: UIButton = {
        var button = UIButton()
        button.setImage(#imageLiteral(resourceName: "send"), for: .normal)
        return button
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
        
        cardView.addSubview(textView)
        textView.anchor(left: cardView.leftAnchor, right: cardView.rightAnchor, bottom: cardView.bottomAnchor, paddingLeft: 10, paddingRight: 10, paddingBottom: 0, height: 40)
        
        cardView.addSubview(sendMessage)
        sendMessage.anchor(right: textView.rightAnchor,paddingRight: 10,width: 25 ,height: 25)
        sendMessage.centerY(inView: textView)
        
        cardView.addSubview(tableView)
        tableView.anchor(top: buttonChat.bottomAnchor, left: cardView.leftAnchor, right: cardView.rightAnchor, bottom: textView.topAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 10, paddingBottom: 10)
 
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

