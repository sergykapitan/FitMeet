//
//  Label.swift
//  MakeStep
//
//  Created by novotorica on 25.08.2021.
//

import UIKit

class Label: UILabel {

  override func drawText(in rect: CGRect) {
    let insets = UIEdgeInsets.init(top: 8, left: 16, bottom: 8, right: 16)
    super.drawText(in: rect.inset(by: insets))
  }
}
