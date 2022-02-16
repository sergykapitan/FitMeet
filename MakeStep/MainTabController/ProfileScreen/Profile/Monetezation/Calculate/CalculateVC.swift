//
//  CalculateVC.swift
//  MakeStep
//
//  Created by Sergey on 06.11.2021.
//

import Foundation
import UIKit
import Combine

class CalculateVC: UIViewController {
    

   
    let calculateView = CalculateVCCode()
    var valueA: Float = 0
    var valueB: Float = 3.99
    var ValueC: Float = 1
    
    
    
    
    override func loadView() {
        super.loadView()
        view = calculateView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        actionButton()
        print( self.view.bounds.height)
       
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
       
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if view.bounds.height <= 488 {
                    
                   calculateView.sliderA.anchor(height:100)
                   calculateView.sliderB.anchor(height:100)
                   calculateView.sliderC.anchor(height:100)
                   calculateView.labelComision.isHidden = true
                   view.layoutIfNeeded()
               } else {
                   calculateView.sliderA.anchor(height:120)
                   calculateView.sliderB.anchor(height:120)
                   calculateView.sliderC.anchor(height:120)
                   calculateView.labelComision.isHidden = false
               }
    }
    private func actionButton() {
        calculateView.labelComision.addTarget(self, action: #selector(actionLabelComission), for: .touchUpInside)
        calculateView.sliderA.onValueChanged = { value in
                if value == 0 || value <= 1000 {
                       self.calculateView.sliderA.slidingInterval = 1
                       self.calculateView.sliderA.maxValue = 5000
               }
               if value > 1000  {
                   self.calculateView.sliderA.slidingInterval = 100
                   self.calculateView.sliderA.maxValue = 10000
               }
               if value > 5000 {
                   self.calculateView.sliderA.slidingInterval = 200
                   self.calculateView.sliderA.maxValue = 20000
               }
               if value > 10000  {
                   self.calculateView.sliderA.slidingInterval = 500
                   self.calculateView.sliderA.maxValue = 50000
               }
              if value > 20000 {
                   self.calculateView.sliderA.slidingInterval = 1000
                   self.calculateView.sliderA.maxValue = 100000
               }
                   print("Slider value: \(value)")
                   self.valueA = Float(value)
                   self.calculateView.labelTotal.text = "$" + String(format: "%.2f", self.calculate())
               }
               calculateView.sliderB.onValueChanged = { value in
                   print("Slider value: \(value)")
                   self.valueB = Float(value)
                   self.calculateView.labelTotal.text = "$" + String(format: "%.2f", self.calculate())
               }
               calculateView.sliderC.onValueChanged = { value in
                   print("Slider value: \(value)")
                   self.ValueC = Float(value)
                   self.calculateView.labelTotal.text = "$" + String(format: "%.2f", self.calculate())
               }
    }
    @objc func actionLabelComission() {
        let vc = CommissionVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    private func calculate() -> Float {
      let price = valueA * valueB * ValueC
      let value = calculatePercentage(value: price,percentageVal: 30)
      return value
    }
    //Calucate percentage based on given values
    private func calculatePercentage(value:Float,percentageVal:Float) -> Float { 
        let val = value * percentageVal
        return val / 100.0
    }
    
    @objc func deleteCell(_ sender: UIButton) -> Void  {
        print(sender.tag)
    }

 
  
}

