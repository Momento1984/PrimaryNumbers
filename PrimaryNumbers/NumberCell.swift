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
  
  func setup(num: Int) {
    numLbl.text = "\(num)"
  }
}
