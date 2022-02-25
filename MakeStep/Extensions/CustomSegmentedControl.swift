//
//  CustomSegmentedControl.swift
//  FitMeet
//
//  Created by novotorica on 31.05.2021.
//

import Foundation

import UIKit
protocol CustomSegmentedControlDelegate:class {
    func change(to index:Int)
}

class CustomSegmentedControl: UIView {
    
    private var buttonTitles:[String]!
    private var buttons: [UIButton]!
    private var selectorView: UIView!
    private var selector: CGFloat?
    
    var textColor:UIColor = UIColor.init(hexString: "#7C7C7C")
    var selectorViewColor: UIColor = .blueColor// UIColor.init(hexString: "#3B58A4")
    var selectorTextColor: UIColor = .blueColor//UIColor.init(hexString: "#3B58A4")
    
    weak var delegate:CustomSegmentedControlDelegate?
    
    public private(set) var selectedIndex : Int = 0
    
    convenience init(frame:CGRect,buttonTitle:[String]) {
        self.init(frame: frame)
        self.buttonTitles = buttonTitle
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.backgroundColor = UIColor.white
        updateView()
    }
    
    func setButtonTitles(buttonTitles:[String]) {
        self.buttonTitles = buttonTitles
        self.updateView()
    }
    
    func setIndex(index:Int) {
        buttons.forEach({ $0.setTitleColor(textColor, for: .normal) })
        let button = buttons[index]
        selectedIndex = index
        button.setTitleColor(selectorTextColor, for: .normal)
        let selectorPosition = frame.width/CGFloat(buttonTitles.count) * CGFloat(index)
        UIView.animate(withDuration: 0.2) {
            self.selectorView.frame.origin.x = selectorPosition// + 60//+ /5.5
        }
    }
    
    @objc func buttonAction(sender:UIButton) {
        for (buttonIndex, btn) in buttons.enumerated() {
            btn.setTitleColor(textColor, for: .normal)
            if btn == sender {
                let selectorPosition = frame.width/CGFloat(buttonTitles.count) * CGFloat(buttonIndex)
                selectedIndex = buttonIndex
                delegate?.change(to: selectedIndex)
                UIView.animate(withDuration: 0.3) {
                    print("SELFHHHHHHH> ================== \(selectorPosition)")
                    print("BTNFrame = \(btn.frame.midX)")
                    
                    if buttonIndex == 2 {
                      //  self.selectorView.frame.origin.x = selectorPosition
                        self.selectorView.frame.origin.x = btn.frame.minX//.midX + 20
                    } else if buttonIndex == 1 {
                        self.selectorView.frame.origin.x = btn.frame.minX//.midX - 2
                    } else {
                        self.selectorView.frame.origin.x = btn.frame.minX//.midX + 2
                    }
                   // selectorPosition //+ 60 //+ /5.5

                }
                btn.setTitleColor(selectorTextColor, for: .normal)
            }
        }
    }
}

//Configuration View
extension CustomSegmentedControl {
    private func updateView() {
        createButton()
        configSelectorView()
        configStackView()
    }
    
    private func configStackView() {
        let stack = UIStackView(arrangedSubviews: buttons)
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.spacing = 15
        stack.distribution = .fillProportionally// .fillEqually
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stack.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        stack.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        stack.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }
    
    private func configSelectorView() {
        let selectorWidth = frame.width / CGFloat(self.buttonTitles.count)/3
        selectorView = UIView(frame: CGRect(x: 0, y: self.frame.height , width: selectorWidth, height: 2))
        selectorView.backgroundColor = selectorViewColor
        addSubview(selectorView)
    }
    
    private func createButton() {
        buttons = [UIButton]()
        buttons.removeAll()
        subviews.forEach({$0.removeFromSuperview()})
        guard let  buttonTit = buttonTitles else { return }
        for buttonTitle in buttonTit {
            let button = UIButton(type: .system)
            button.setTitle(buttonTitle, for: .normal)
            button.addTarget(self, action:#selector(CustomSegmentedControl.buttonAction(sender:)), for: .touchUpInside)
            button.setTitleColor(textColor, for: .normal)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
            buttons.append(button)
        }
        buttons[0].setTitleColor(selectorTextColor, for: .normal)
    }
    
    
}
