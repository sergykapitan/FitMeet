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
//        view.layer.cornerRadius = 8
//        view.layer.borderWidth = 0.8
//        view.layer.borderColor = .init(red: 0, green: 0, blue: 0, alpha: 0)
        return view
        }()
    var tableView: UITableView = {
        let table = UITableView()
        return table
    }()
    var buttonChat: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "Back1-2"), for: .normal)
       // button.backgroundColor = .blue
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
        
//        cardView.addSubview(textView)
//        textView.anchor(left: cardView.leftAnchor, right: cardView.rightAnchor, bottom: cardView.bottomAnchor, paddingLeft: 10, paddingRight: 10, paddingBottom: 0, height: 40)
        
//        cardView.addSubview(sendMessage)
//        sendMessage.anchor(right: textView.rightAnchor,paddingRight: 10,width: 25 ,height: 25)
//        sendMessage.centerY(inView: textView)
        
        cardView.addSubview(sendMessage)
        sendMessage.anchor(right: cardView.rightAnchor,bottom: cardView.bottomAnchor,paddingRight: 2, paddingBottom: 18,width: 64 ,height: 60)
        
        cardView.addSubview(tableView)
        tableView.anchor(top: buttonChat.bottomAnchor, left: cardView.leftAnchor, right: cardView.rightAnchor, bottom: sendMessage.topAnchor, paddingTop: 10, paddingLeft: 0, paddingRight: 0, paddingBottom: 0)
 
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

