//
//  capitalizeFirstLetter.swift
//  WordPositive
//
//  Created by Nathaniel Brown on 9/18/21.
//

import Foundation

extension String {
  func capitalizingFirstLetter() -> String {
    return prefix(1).capitalized + dropFirst()
  }
  
  mutating func capitalizeFirstLetter() {
    self = self.capitalizingFirstLetter()
  }
}
