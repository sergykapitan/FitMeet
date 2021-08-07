//
//  ParentControllwerCode.swift
//  FitMeet
//
//  Created by novotorica on 16.06.2021.
//

import UIKit

final class ParentControllwerCode: UIView {

    //MARK: - First layer in TopView
    let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
            return view
        }()

    var contentView: UIView = {
        let view = UIView()
        return view
    }()
    var segmentControll: TabySegmentedControl = {
        
        let items = ["Streams", "Coaches", "Categories"]
        let segment = TabySegmentedControl(items: items)
        segment.selectedSegmentIndex = 0
        return segment
        
    }()
   
    //MARK: - initial
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createCardViewLayer()
    
    }
    
    //MARK: - constraint First Layer
    
    func createCardViewLayer() {
        addSubview(cardView)
        cardView.fillFull(for: self)
        cardView.addSubview(segmentControll)
        segmentControll.anchor(top: cardView.topAnchor, left: cardView.leftAnchor, paddingTop: 5, paddingLeft: 10, height: 30)
        
        cardView.addSubview(contentView)
        contentView.anchor(top: segmentControll.bottomAnchor, left: cardView.leftAnchor, right: cardView.rightAnchor, bottom: cardView.bottomAnchor, paddingTop: 10, paddingLeft: 0, paddingRight: 0, paddingBottom: 0)
        

    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
