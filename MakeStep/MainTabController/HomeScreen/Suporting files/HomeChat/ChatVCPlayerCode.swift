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

    var imageNotToken: UIImageView = {
        let view = UIImageView()
        view.image = #imageLiteral(resourceName: "Group1-3")
        return view
    }()
    
    var buttonComm: UIButton = {
        var button = UIButton()
        return button
    }()
    var imageComm: UIImageView = {
        let image = UIImageView()
        image.image =  #imageLiteral(resourceName: "icons8-expand-arrow-100")
        image.tintColor = .black
        return image
        }()
    var labelComm: UILabel = {
        let label = UILabel()
        label.text = "Comments"
        label.textColor = .black
        return label
    }()
    var textView: UITextView = {
        let text = UITextView()
        text.layer.cornerRadius = 20
        text.layer.borderWidth = 1
        text.layer.borderColor = UIColor(hexString: "DADADA").cgColor
        text.backgroundColor = UIColor(hexString: "#F6F6F6")
        text.textColor = .lightGray
       // text.textContainerInset = UIEdgeInsets(top: 5, left: 10, bottom: 0, right: 0)
        
        text.font = UIFont.systemFont(ofSize: 18)
       // text.sizeToFit()
       // text.layoutIfNeeded ()
       // text.isScrollEnabled = false
        //text.isScrollEnabled = false
        //text.clipsToBounds = false
        return text
    }()
    var sendMessage: UIButton = {
        var button = UIButton()
        button.setImage(#imageLiteral(resourceName: "Frame"), for: .normal)
        return button
    }()
    var buttonCloseChat: UIButton = {
        var button = UIButton()
        button.setImage(#imageLiteral(resourceName: "icons8"), for: .normal)
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
  
        cardView.addSubview(buttonComm)
        buttonComm.anchor(top: cardView.topAnchor, left: cardView.leftAnchor,
                          paddingTop: 10, paddingLeft: 15, width: 60, height: 30)
        buttonComm.addSubview(imageComm)
        
        imageComm.anchor(left: buttonComm.leftAnchor,  paddingLeft: 10,width: 15,height: 15)
        imageComm.centerY(inView: buttonComm)
        
        buttonComm.addSubview(labelComm)
        labelComm.anchor( left: imageComm.rightAnchor, paddingLeft: 10)
        labelComm.centerY(inView: buttonComm)
        
        cardView.addSubview(sendMessage)
        sendMessage.anchor(right: cardView.rightAnchor,bottom: cardView.bottomAnchor,paddingRight: 10, paddingBottom: 15,width: 70 ,height: 60)
        
//        cardView.addSubview(textView)
//        textView.anchor(left: cardView.leftAnchor, right: sendMessage.leftAnchor, bottom: cardView.bottomAnchor, paddingLeft: 10, paddingRight: 10, paddingBottom: 10)//,height: 40
 
        cardView.addSubview(buttonCloseChat)
        buttonCloseChat.anchor( top: cardView.topAnchor,paddingTop: 5,width: 30, height: 30)
        buttonCloseChat.centerX(inView: cardView)
        
        cardView.addSubview(tableView)
        tableView.anchor(top: buttonCloseChat.bottomAnchor, left: cardView.leftAnchor, right: cardView.rightAnchor, bottom: sendMessage.topAnchor, paddingTop: 10, paddingLeft: 5, paddingRight: 10, paddingBottom: 10)
        
        cardView.addSubview(imageNotToken)
        imageNotToken.anchor( width: 100, height: 100)
        imageNotToken.centerX(inView: cardView)
        imageNotToken.centerY(inView: cardView)
 
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

