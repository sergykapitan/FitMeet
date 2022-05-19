//
//  InstantPanGestureRecognizer.swift
//  MakeStep
//
//  Created by Sergey on 16.04.2022.
//

import UIKit

class InstantPanGestureRecognizer: UIPanGestureRecognizer {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        if (self.state == .began) { return }
        super.touchesBegan(touches, with: event)
        self.state = .began
    }
}
