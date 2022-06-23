//
//  UserPlayerCell.swift
//  MakeStep
//
//  Created by Sergey on 20.06.2022.
//

import Foundation
import UIKit
import Kingfisher



final class UserPlayerCell: UICollectionViewCell {

    //MARK: - Properties
    static let reuseID = "UserPlayerCell"
        
    //MARK: - UI
    let photoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
      //  imageView.clipsToBounds = true
        return imageView
    }()
    //MARK:- Events
      override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
          super.touchesBegan(touches, with: event)
          animate(isHighlighted: true)
      }

      override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
          super.touchesEnded(touches, with: event)
          animate(isHighlighted: false)
      }

      override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
          super.touchesCancelled(touches, with: event)
          animate(isHighlighted: false)
      }

      //MARK:- Private functions
      private func animate(isHighlighted: Bool, completion: ((Bool) -> Void)?=nil) {
          let animationOptions: UIView.AnimationOptions = [.allowUserInteraction]
          if isHighlighted {
              UIView.animate(withDuration: 0.5,
                             delay: 0,
                             usingSpringWithDamping: 1,
                             initialSpringVelocity: 0,
                             options: animationOptions, animations: {
                              self.transform = .init(scaleX: 2, y: 2)
                 
              }, completion: completion)
          } else {
              UIView.animate(withDuration: 0.5,
                             delay: 0,
                             usingSpringWithDamping: 1,
                             initialSpringVelocity: 0,
                             options: animationOptions, animations: {
                              self.transform = .identity
              }, completion: completion)
          }
      }
 
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 50, left: 10, bottom: 50, right: 0))
    }
   
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
        initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImage.image = nil
    }
    
    private func initUI() {
        clipsToBounds = true
        backgroundColor = UIColor(red: 198/255, green: 198/255, blue: 198/255, alpha: 1)
        contentView.addSubview(photoImage)
       
        
    }
    
    private func initLayout() {
        photoImage.anchor(top: contentView.topAnchor,
                          left: contentView.leftAnchor,
                          right: contentView.rightAnchor,
                          bottom: contentView.bottomAnchor,
                          paddingTop: 0,
                          paddingLeft: 0,
                          paddingRight: 0,
                          paddingBottom: 0 )

    }

    func configureCell(albumName: Int, url: URL,artistName: String) {
        photoImage.kf.setImage(with: url)
       
    }
}

