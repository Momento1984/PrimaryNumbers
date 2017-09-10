//
//  NumberCell.swift
//  PrimaryNumbers
//
//  Created by Виталий Антипов on 03.08.17.
//  Copyright © 2017 Виталий Антипов. All rights reserved.
//

import UIKit

class NumberCell: UICollectionViewCell {
  @IBOutlet var numLbl: UILabel!
  
	func setup(num: Int, selected: Bool) {
		if selected {
			self.layer.borderWidth = 2
			self.layer.borderColor = UIColor.lightGray.cgColor
		} else {
			self.layer.borderWidth = 0
		}
    numLbl.text = "\(num)"
  }
}
