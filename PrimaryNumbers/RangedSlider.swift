//
//  RangedSlider.swift
//  PrimaryNumbers
//
//  Created by Виталий Антипов on 08.10.17.
//  Copyright © 2017 Виталий Антипов. All rights reserved.
//

import UIKit

class RangedSlider: UIView {
  
  @IBOutlet private var minSlider: UISlider!
  @IBOutlet private var maxSlider: MaxRangedSlider!
  
	@IBOutlet private var minTxt: UITextField!
	@IBOutlet private var maxTxt: UITextField!
	
	var valuesChangedCallback: ((Int, Int)->())?
	
	static func create() -> RangedSlider {
		let bundle = Bundle(for: RangedSlider.self)
		let nib = UINib(nibName: "RangedSlider", bundle: bundle)
		let view = nib.instantiate(withOwner: self, options: nil)[0] as! RangedSlider
		return view
	}
  
  @IBAction private func maxSliderChanged(_ sender: Any) {
    if maxSlider.value < minSlider.value {
      maxSlider.setValue(minSlider.value, animated: true)
    }
		maxTxt.text = "\(Int(maxSlider.value))"
		minTxt.text = "\(Int(minSlider.value))"

  }
	
  @IBAction private func minSliderChanged(_ sender: Any) {
    if minSlider.value > maxSlider.value {
      minSlider.setValue(maxSlider.value, animated: true)
    }
		minTxt.text = "\(Int(minSlider.value))"
		maxTxt.text = "\(Int(maxSlider.value))"

  }
	
	@IBAction private func maxSliderUp(_ sender: Any) {
		maxTxt.text = "\(Int(maxSlider.value))"
		valuesChangedCallback?(Int(minSlider.value), Int(maxSlider.value))
		
		if maxSlider.value > (maxSlider.maximumValue * 0.8) {
			maxSlider.maximumValue *= 1.5
		}
	}
	
	@IBAction private func minSliderUp(_ sender: Any) {
		minTxt.text = "\(Int(minSlider.value))"
		valuesChangedCallback?(Int(minSlider.value), Int(maxSlider.value))
	}
	
	
}


