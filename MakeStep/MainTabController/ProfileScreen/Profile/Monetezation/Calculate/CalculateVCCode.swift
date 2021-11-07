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
        slide.title = "Subscribers"
        slide.unit = "𓁹"
        slide.unitPosition = .back
        slide.limitValueIndicator = "Max"
        slide.minValue = 0
        slide.maxValue = 10000
        slide.defaultValue = 10
        slide.trackHeight = 14
        slide.activeTrackColor = UIColor(hexString: "#3B58A4")
        slide.inactiveTrackColor = UIColor(red: 0.91, green: 0.91, blue: 0.91, alpha: 1.0)
        slide.thumbSliderRadius = 10
        slide.thumbSliderBackgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        slide.rangeValueTextFont = UIFont.systemFont(ofSize: 12)
        slide.rangeValueTextColor =  UIColor(red: 0.62, green: 0.65, blue: 0.68, alpha: 1.0)
        slide.titleTextFont = UIFont.systemFont(ofSize: 18)
        slide.titleTextColor = UIColor(hexString: "#868686")
        slide.bubbleStrokeWidth = 3
        slide.bubbleCornerRadius = 12
        slide.bubbleValueTextFont = UIFont.boldSystemFont(ofSize: 12)
        slide.bubbleOutlineColor = UIColor(hexString: "#3B58A4")
        slide.bubbleValueTextColor = UIColor(red: 0.62, green: 0.65, blue: 0.68, alpha: 1.0)
        slide.vibrateOnLimitReached = true
        slide.allowLimitValueBypass = false
        slide.isDisabled = false
        return slide
    }()
    let sliderB : SliderFloat = {
        let slide = SliderFloat()
        slide.title = "Monthly subscription price"
        slide.unit = "$"
        slide.unitPosition = .back
        slide.minValue = 3.99
        slide.maxValue = 39.99
        slide.defaultValue = 10.99
        slide.slidingInterval = 1
        slide.trackHeight = 14
        slide.activeTrackColor = UIColor(hexString: "#F9A000")
        slide.inactiveTrackColor = UIColor(red: 0.91, green: 0.91, blue: 0.91, alpha: 1.0)
        slide.thumbSliderRadius = 10
        slide.thumbSliderBackgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        slide.rangeValueTextFont = UIFont.systemFont(ofSize: 12)
        slide.rangeValueTextColor =  UIColor(red: 0.62, green: 0.65, blue: 0.68, alpha: 1.0)
        slide.titleTextFont = UIFont.systemFont(ofSize: 18)
        slide.titleTextColor = UIColor(hexString: "#868686")
        slide.bubbleStrokeWidth = 3
        slide.bubbleCornerRadius = 12
        slide.bubbleValueTextFont = UIFont.boldSystemFont(ofSize: 12)
        slide.bubbleOutlineColor = UIColor(hexString: "#F9A000")
        slide.bubbleValueTextColor = UIColor(red: 0.62, green: 0.65, blue: 0.68, alpha: 1.0)
        slide.vibrateOnLimitReached = true
        slide.allowLimitValueBypass = false
        slide.isDisabled = false
        return slide
    }()
    let sliderC : iLabeledSeekSlider = {
        let slide = iLabeledSeekSlider()
        slide.title = "Period Type"
        slide.unit = ""
        slide.boolValue = false
        slide.unitPosition = .back
        slide.minValue = 1
        slide.maxValue = 12
        slide.defaultValue = 6
        slide.slidingInterval = 1
        slide.trackHeight = 14
        slide.activeTrackColor = UIColor(hexString: "#41C75F")
        slide.inactiveTrackColor = UIColor(red: 0.91, green: 0.91, blue: 0.91, alpha: 1.0)
        slide.thumbSliderRadius = 10
        slide.thumbSliderBackgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        slide.rangeValueTextFont = UIFont.systemFont(ofSize: 12)
        slide.rangeValueTextColor =  UIColor(red: 0.62, green: 0.65, blue: 0.68, alpha: 1.0)
        slide.titleTextFont = UIFont.systemFont(ofSize: 18)
        slide.titleTextColor = UIColor(hexString: "#868686")
        slide.bubbleStrokeWidth = 3
        slide.bubbleCornerRadius = 12
        slide.bubbleValueTextFont = UIFont.boldSystemFont(ofSize: 12)
        slide.bubbleOutlineColor = UIColor(hexString: "#41C75F")
        slide.bubbleValueTextColor = UIColor(red: 0.62, green: 0.65, blue: 0.68, alpha: 1.0)
        slide.vibrateOnLimitReached = true
        slide.allowLimitValueBypass = false
        slide.isDisabled = false
        return slide
    }()
    var fourAndLine: OneLine = {
        let line = OneLine()
        return line
    }()
    var labelTot: UILabel = {
        let label = UILabel()
        label.text = "Total"
        label.font = UIFont.boldSystemFont(ofSize: 26)
        return label
    }()
    
    var labelTotal: UILabel = {
        let label = UILabel()
        label.text = "$ 0.00"
        label.font = UIFont.boldSystemFont(ofSize: 36)
        label.textColor = UIColor(hexString: "#3B58A4")
        return label
    }()
    
    var labelComision: UILabel = {
        let label = UILabel()
        label.text = "Service commission 30%" + " ➔"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor(hexString: "#868686")
        return label
    }()
    
    var labelAfterComision: UILabel = {
        let label = UILabel()
        label.text = "After deducting the service commission"
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = UIColor(hexString: "#3B58A4")
        return label
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
                       height: 120)
        cardView.addSubview(sliderB)
        sliderB.anchor(top: sliderA.bottomAnchor,
                       left: cardView.leftAnchor,
                       right: cardView.rightAnchor,
                       paddingTop: 20, paddingLeft: 16, paddingRight: 16,
                       height: 120)
        cardView.addSubview(sliderC)
        sliderC.anchor(top: sliderB.bottomAnchor,
                       left: cardView.leftAnchor,
                       right: cardView.rightAnchor,
                       paddingTop: 20, paddingLeft: 16, paddingRight: 16,
                       height: 120)
        cardView.addSubview(fourAndLine)
        fourAndLine.anchor(top: sliderC.bottomAnchor, left: cardView.leftAnchor, right: cardView.rightAnchor,  paddingTop: 10, paddingLeft: 16, paddingRight: 16 )
        
        cardView.addSubview(labelTot)
        labelTot.anchor( left: cardView.leftAnchor, bottom: cardView.bottomAnchor,  paddingLeft: 16, paddingBottom: 64)
        cardView.addSubview(labelTotal)
        labelTotal.anchor( right: cardView.rightAnchor,  paddingRight: 16 )
        labelTotal.centerY(inView: labelTot)
        
        cardView.addSubview(labelComision)
        labelComision.anchor( right: cardView.rightAnchor, bottom: labelTotal.topAnchor, paddingRight: 16, paddingBottom: 18)
        
        cardView.addSubview(labelAfterComision)
        labelAfterComision.anchor(top: labelTotal.bottomAnchor,  right: cardView.rightAnchor, paddingTop: 4, paddingRight: 16)
 
    }
   
}
