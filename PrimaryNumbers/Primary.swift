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
  private(set) var numbers = [Int]()
  
  private let onProgress: (Float) -> ()
  
  init(num: Int, onProgress: @escaping (Float) -> ()) {
    self.num = num
    self.onProgress = onProgress
  }
  
  func calcAll() {
    let end = Int(sqrt(Double(num + 1))) + 1
    var isPrimary = [Bool](repeating: true, count: num + 1)
    for i in 2..<end {
      if isPrimary[i] {
        onProgress(Float(i) / Float(end))
        for k in stride(from: i * i, to: num + 1, by: i) {
          isPrimary[k] = false
        }
      }
    }
    
    numbers = isPrimary.dropFirst(1).indices.flatMap { isPrimary[$0] ? $0 : nil }
  }
  
  func clear() {
    numbers = []
  }
  
  func index(of number: Int) -> (Int, Int?) {
    var hi = numbers.count
    var lo = 0
    while lo < hi {
      let mid = (lo + hi) / 2
      if numbers[mid] == number {
        lo = mid
        break
      } else {
        if number < numbers[mid] {
          hi = mid
        } else {
          lo = mid + 1
        }
      }
    }
    if lo == numbers.count {
      return (lo - 2, lo - 1)
    }
    if numbers[lo] == number {
      return (lo, nil)
    } else {
			if lo > 0 {
				return (lo - 1, lo)
			} else {
				return (lo, lo + 1)
			}
			
    }
  }
}
