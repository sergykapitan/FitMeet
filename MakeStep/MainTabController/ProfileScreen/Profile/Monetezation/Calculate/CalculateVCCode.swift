//
//  CalculateVCCode.swift
//  MakeStep
//
//  Created by Sergey on 06.11.2021.
//

import Foundation
import UIKit
import iLabeledSeekSlider


final class CalculateVCCode: UIView {
    
    //MARK: - UI
    let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hexString: "#F9FAFC")
        return view
    }()
    let sliderA : iLabeledSeekSlider = {
        let slide = iLabeledSeekSlider()
        slide.title = "Amount"
        slide.unit = "€"
        slide.unitPosition = .back
        slide.limitValueIndicator = "Max"
        slide.minValue = 0
        slide.maxValue = 10000
        slide.defaultValue = 0
       // slide.limitValue = 850
       // slide.valuesToSkip = [300, 350]
        slide.trackHeight = 14
        slide.activeTrackColor = UIColor(hexString: "#3B58A4")//UIColor(red: 1.0, green: 0.14, blue: 0.0, alpha: 1.0)
        slide.inactiveTrackColor = UIColor(red: 0.91, green: 0.91, blue: 0.91, alpha: 1.0)
        slide.thumbSliderRadius = 10
        slide.thumbSliderBackgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        slide.rangeValueTextFont = UIFont.systemFont(ofSize: 12)
        slide.rangeValueTextColor =  UIColor(red: 0.62, green: 0.65, blue: 0.68, alpha: 1.0)
        slide.titleTextFont = UIFont.systemFont(ofSize: 12)
        slide.titleTextColor = UIColor(red: 0.62, green: 0.65, blue: 0.68, alpha: 1.0)
        slide.bubbleStrokeWidth = 3
        slide.bubbleCornerRadius = 12
        slide.bubbleValueTextFont = UIFont.boldSystemFont(ofSize: 12)
        slide.bubbleOutlineColor = UIColor(hexString: "#3B58A4")//UIColor(red: 0.91, green: 0.91, blue: 0.91, alpha: 1.0)
        slide.bubbleValueTextColor = UIColor(red: 0.62, green: 0.65, blue: 0.68, alpha: 1.0)
        slide.vibrateOnLimitReached = true
        slide.allowLimitValueBypass = false
        slide.isDisabled = false
        return slide
    }()
   
    // MARK: - Init
    init() {
        super.init(frame: CGRect.zero)
        initUI()
       
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func initUI() {
        addSubview(cardView)
        cardView.fillSuperview()
        
        cardView.addSubview(sliderA)
        sliderA.anchor(top: cardView.topAnchor,
                       left: cardView.leftAnchor,
                       right: cardView.rightAnchor,
                       paddingTop: 20, paddingLeft: 16, paddingRight: 16,
                       height: 90)
        
      
 
    }
   
}
