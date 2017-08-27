//
//  Primary.swift
//  PrimaryNumbers
//
//  Created by Виталий Антипов on 04.08.17.
//  Copyright © 2017 Виталий Антипов. All rights reserved.
//
import Foundation
class Primary {
  private(set) var num: Int
  private let maxPart = 10000
  private var offset = 0
  private(set) var numbers = [Int]()
  private var isPrimary = [Bool]()
  private var endPart = 0


  init(num: Int) {
    self.num = num

  }
  
  var hasNext: Bool {
    return endPart != num
  }
  
  func calcNext() -> [Int] {
    endPart = min(offset + maxPart, num)
    isPrimary += [Bool](repeating: true, count: min(maxPart, num - offset))
    let end = Int(sqrt(Double(endPart))) + 1
    for i in 2..<end {
      if isPrimary[i] {
        print(i)
        for k in stride(from: i*i, to: endPart, by: i) {
          isPrimary[k] = false
        }
      }
    }

    let partNumbers = isPrimary.dropFirst(offset).indices.flatMap { isPrimary[$0] ? $0 : nil }
    numbers += partNumbers
    offset = endPart

    return partNumbers
  }
}
