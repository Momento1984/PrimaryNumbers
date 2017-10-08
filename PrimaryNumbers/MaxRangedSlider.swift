//
//  MaxRangedSlider.swift
//  PrimaryNumbers
//
//  Created by Виталий Антипов on 08.10.17.
//  Copyright © 2017 Виталий Антипов. All rights reserved.
//
import UIKit
class MaxRangedSlider: UISlider {
  override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
    let valueWidth = self.maximumValue - self.minimumValue
    let thumbPosition = (CGFloat(value) * frame.size.width) / CGFloat(valueWidth)
    
    if ((thumbPosition - 15) < point.x) && (point.x < (thumbPosition + 15)) {
      return true
    } else {
      return false
    }
    
  }
}
