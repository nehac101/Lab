//
//  ViewController.swift
//  FindMyCar
//
//  Created by Neha Choudhari on 11/1/22.
//  Copyright © 2022 Steph K. Ananth. All rights reserved.
//

import Foundation

class ViewController: ObservableObject {
  
  var currLocation = Location()
  var carLocation = Location()
  
  func generateTitle() -> String {
    let message = "Your car is currently at:\n(\(self.carLocation.latitude), \(self.carLocation.longitude))"
    return message
  }

  func generateMessage() -> String {
    let message = "\nWhen you want to map to this location, simply press the \"Where is my car?\" button."
    return message
  }

  
}

