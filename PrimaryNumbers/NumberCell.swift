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
  override var isSelected: Bool {
    didSet {
      if isSelected {
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.lightGray.cgColor
      } else {
        self.layer.borderWidth = 0
      }
    }
  }
	func setup(num: Int) {
    numLbl.text = "\(num)"
  }
}
