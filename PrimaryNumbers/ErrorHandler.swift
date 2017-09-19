//
//  ErrorHandler.swift
//  PrimaryNumbers
//
//  Created by Виталий Антипов on 19.09.17.
//  Copyright © 2017 Виталий Антипов. All rights reserved.
//

import Foundation
import UIKit


enum NumbersError: Error {
  case incorrectValue
  case tooBig(num: Int)
  case primaryNotExist
}

class ErrorHandler {
  
  static func `try`<T>(_ danger: () throws -> T) -> T? {
    do {
     return try danger()
      
    } catch NumbersError.tooBig(let num) {
      alert(title: "Поиск", message: "Число \(num) выходит за пределы рассчитанных")
      
    } catch NumbersError.incorrectValue {
      alert(title: "Ошибка", message: "Допустимо только положительное число")
      
    } catch NumbersError.primaryNotExist {
      alert(title: "Поиск", message: "Простые числа еще не рассчитаны")
    }
  
    catch {
      
    }
    return nil

  }
  
  private static func alert(title: String, message: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Закрыть", style: .cancel, handler: nil))
    topVC()?.present(alert, animated: true, completion: nil)
    
  }
  
  private static func topVC() -> UIViewController? {
    guard let root = UIApplication.shared.keyWindow?.rootViewController else {
      return nil
    }
    return root.navigationController?.topViewController ?? root
  }
  
}
