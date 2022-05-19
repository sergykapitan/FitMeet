//
//  Task.swift
//  FitMeet
//
//  Created by novotorica on 19.06.2021.
//

import Foundation
import UIKit

class Task {
  let name: String
  let creationDate = Date()
  var completed = false
  
  init(name: String) {
    self.name = name
  }
}
extension UISlider {
    public func addTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        addGestureRecognizer(tap)
    }

    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: self)
        let percent = minimumValue + Float(location.x / bounds.width) * maximumValue
        setValue(percent, animated: true)
        sendActions(for: .valueChanged)
    }
}
