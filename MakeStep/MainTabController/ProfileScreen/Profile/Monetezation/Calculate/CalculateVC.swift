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

    override func loadView() {
        super.loadView()
        view = calculateView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        actionButton()
        calculateView.sliderA.onValueChanged = { value in
            if value == 0 || value <= 500 {
                self.calculateView.sliderA.slidingInterval = 1
                self.calculateView.sliderA.maxValue = 10000
        } else  if value > 500 {
            self.calculateView.sliderA.slidingInterval = 1000
            self.calculateView.sliderA.maxValue = 100000
        }
            print("Slider value: \(value)")
        }
      
    }
    private func actionButton() {
       
    }
  
    
    @objc func deleteCell(_ sender: UIButton) -> Void  {
        print(sender.tag)
    }

 
  
}

