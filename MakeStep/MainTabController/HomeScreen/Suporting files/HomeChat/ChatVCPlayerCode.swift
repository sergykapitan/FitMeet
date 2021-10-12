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
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
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
        text.layer.borderColor = UIColor(hexString: "DADADA").cgColor
        text.backgroundColor = UIColor(hexString: "#F6F6F6")
        text.textColor = .lightGray
        //text.setLeftPaddingPoints(20)
        return text
    }()
    var sendMessage: UIButton = {
        var button = UIButton()
        //button.setImage(#imageLiteral(resourceName: "Frame"), for: .normal)
        button.setBackgroundImage(#imageLiteral(resourceName: "Frame"), for: .normal)
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
        sendMessage.anchor(right: cardView.rightAnchor,bottom: cardView.bottomAnchor,paddingRight: 2, paddingBottom: 18,width: 64 ,height: 60)
        
//        cardView.addSubview(textView)
//        textView.anchor(left: cardView.leftAnchor, right: sendMessage.leftAnchor, bottom: cardView.bottomAnchor, paddingLeft: 10, paddingRight: 10, paddingBottom: 10)//,height: 40
 
        cardView.addSubview(buttonCloseChat)
        buttonCloseChat.anchor( top: cardView.topAnchor,paddingTop: 5,width: 40, height: 30)
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

