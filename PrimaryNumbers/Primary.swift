//
//  Primary.swift
//  PrimaryNumbers
//
//  Created by Виталий Антипов on 04.08.17.
//  Copyright © 2017 Виталий Антипов. All rights reserved.
//

class Primary {
  let num: Int
  init(num: Int) {
    self.num = num
  }
  
  func calc() -> [Pair] {
    var isPrimary = [Int : Bool]()
    for i in 0..<num + 1 {
      isPrimary[i] = true
    }
    for i in 2..<num + 1 {
      if isPrimary[i]! {
        for k in stride(from: i*i, through: num, by: i) {
          isPrimary[k] = false
        }
      }
    }
    
    return isPrimary.sorted(by: { $0.key < $1.key }).map{ (value: $0.key, primary: $0.value) }
  }
}
