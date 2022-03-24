//
//  ChatVCPlayerCode.swift
//  MakeStep
//
//  Created by novotorica on 26.07.2021.
//

import UIKit


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
    var View: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.shadowOffset = CGSize(width: 10,
                                          height: 10)
        view.layer.shadowRadius = 5
        view.layer.shadowOpacity = 0.3
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = UIScreen.main.scale
        view.layer.cornerRadius = 20
        return view
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
        button.layer.shadowOffset = CGSize(width: 3, height: 3)
        button.layer.shadowOpacity = 0.8
        button.layer.shadowRadius = 2
        button.layer.shadowColor = CGColor.init(srgbRed: 1, green: 0, blue: 0, alpha: 1)
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
          
        cardView.addSubview(sendMessage)
        sendMessage.anchor(right: cardView.rightAnchor,bottom: cardView.bottomAnchor,paddingRight: 2, paddingBottom: 18,width: 64 ,height: 60)
        
        cardView.addSubview(View)
        View.anchor( left: cardView.leftAnchor, right: sendMessage.leftAnchor, bottom: cardView.bottomAnchor, paddingLeft: 20, paddingRight: 0, paddingBottom: 30, height: 18)

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

