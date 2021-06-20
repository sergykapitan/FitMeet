//
//  Task.swift
//  FitMeet
//
//  Created by novotorica on 19.06.2021.
//

import Foundation

class Task {
  let name: String
  let creationDate = Date()
  var completed = false
  
  init(name: String) {
    self.name = name
  }
}
