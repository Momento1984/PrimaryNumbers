//
//  RangedSlider.swift
//  PrimaryNumbers
//
//  Created by Виталий Антипов on 08.10.17.
//  Copyright © 2017 Виталий Антипов. All rights reserved.
//

import UIKit

class RangedSlider: UIView {
  
  @IBOutlet var minSlider: UISlider!
  @IBOutlet var maxSlider: MaxRangedSlider!
  
  static func create() -> RangedSlider {
    let bundle = Bundle(for: RangedSlider.self)
    let nib = UINib(nibName: "RangedSlider", bundle: bundle)
    let view = nib.instantiate(withOwner: self, options: nil)[0] as! RangedSlider
    return view
  }
  
  @IBAction func maxSliderChanged(_ sender: Any) {
    if maxSlider.value < minSlider.value {
      maxSlider.setValue(minSlider.value, animated: true)
    }
  }
  
  @IBAction func minSliderChanged(_ sender: Any) {
    if minSlider.value > maxSlider.value {
      minSlider.setValue(maxSlider.value, animated: true)
    }
  }
}


