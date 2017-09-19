//
//  Presenter.swift
//  PrimaryNumbers
//
//  Created by Виталий Антипов on 19.09.17.
//  Copyright © 2017 Виталий Антипов. All rights reserved.
//
import Foundation

class Presenter {

  private(set) var primary: Primary?

  func getCorrectSearchNumber(text: String) throws -> Int {
    let number = try getCorrectNumber(text: text)

    guard let primary = primary else {
      throw NumbersError.primaryNotExist
    }

    if number > primary.num {
      throw NumbersError.tooBig(num: number)
    }
    return number
  }

  func getCorrectNumber(text: String) throws -> Int {
    guard let number = Int(text), number > 0 else {
      throw NumbersError.incorrectValue
    }
    return number
  }

  func calc(for number: Int, onProgress: @escaping (Float) -> (), completion: @escaping () -> ()) {

    DispatchQueue.global(qos: .userInitiated).async { [unowned self] in
      self.primary = Primary(num: number, onProgress: onProgress)
      _ = self.primary!.calcAll()
      completion()
    }
  }
  
  func cleanPrimary() {
    primary = nil
  }
  
  var countNumbers: Int {
    return primary?.numbers.count ?? 0
  }
  
  func number(at index: Int) -> Int? {
    if index < countNumbers {
      return primary?.numbers[index]
    } else {
      return nil
    }
  }
}
