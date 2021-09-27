//
//  trimTrailingWhitespace.swift
//  WordPositive
//
//  Created by Nathaniel Brown on 9/18/21.
//

import Foundation

extension String {
  func trimmingTrailingSpaces() -> String {
    var t = self
    while t.hasSuffix(" ") {
      t = "" + t.dropLast()
    }
    return t
  }
  
  mutating func trimmedTrailingSpaces() {
    self = self.trimmingTrailingSpaces()
  }
  
}
