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
        button.setImage(#imageLiteral(resourceName: "icons8"), for: .normal)
        return button
    }()
    
    var view : UILabel = {
        let view = UILabel()
        view.frame = CGRect(x: 0, y: 0, width: 31, height: 4)
        view.backgroundColor = .white
        view.layer.backgroundColor = UIColor.gray.cgColor//UIColor(red: 0.854, green: 0.854, blue: 0.854, alpha: 1).cgColor
        view.layer.cornerRadius = 20
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
      //  label.font = UIFont.systemFont(ofSize: 18)
        return label
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
        buttonChat.anchor(top: cardView.topAnchor, paddingTop: 10,width: 40,height: 30)
        buttonChat.centerX(inView: cardView)
        
        cardView.addSubview(buttonComm)
        buttonComm.anchor(top: cardView.topAnchor, left: cardView.leftAnchor,
                          paddingTop: 10, paddingLeft: 15, width: 60, height: 30)
        buttonComm.addSubview(imageComm)
        imageComm.anchor(left: buttonComm.leftAnchor,  paddingLeft: 10,width: 15,height: 15)
        imageComm.centerY(inView: buttonComm)
        
        buttonComm.addSubview(labelComm)
        labelComm.anchor( left: imageComm.rightAnchor, paddingLeft: 10)
        labelComm.centerY(inView: buttonComm)
        
        
        cardView.addSubview(textView)
        textView.anchor(left: cardView.leftAnchor, right: cardView.rightAnchor, bottom: cardView.bottomAnchor, paddingLeft: 10, paddingRight: 10, paddingBottom: 10, height: 40)
        
        cardView.addSubview(sendMessage)
        sendMessage.anchor(right: textView.rightAnchor,paddingRight: 10,width: 45 ,height: 45)
        sendMessage.centerY(inView: textView)
        
        cardView.addSubview(tableView)
        tableView.anchor(top: buttonChat.bottomAnchor, left: cardView.leftAnchor, right: cardView.rightAnchor, bottom: textView.topAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 10, paddingBottom: 10)
 
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

