//
//  ViewController.swift
//  PrimaryNumbers
//
//  Created by Виталий Антипов on 03.08.17.
//  Copyright © 2017 Виталий Антипов. All rights reserved.
//

import UIKit

typealias Pair = (value: Int, primary: Bool)
class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

  @IBOutlet var collectionView: UICollectionView!
  @IBOutlet var numLbl: UITextField!
  private var isPrimary = [Pair]()
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupUI()
  }
  
  func setupUI() {
    collectionView.dataSource = self
    collectionView.delegate = self

  }

  @IBAction func calc(_ sender: Any) {
    self.view.endEditing(true)
    guard let text = numLbl.text, let number = Int(text) else {
      return
    }
    if number > 1 {
      let primary = Primary(num: number)
      isPrimary = primary.calc()
      collectionView.reloadData()
    }
    
  }
  
  @IBAction func collect(_ sender: UIButton) {
    let nonPrimaryIndixes = isPrimary.flatMap { $0.primary ? nil : IndexPath(row: $0.value - 1, section: 0) }
    isPrimary = isPrimary.filter { $0.primary }
    if isPrimary.count < 5000 {
      collectionView.deleteItems(at: nonPrimaryIndixes)
    } else {
      collectionView.reloadData()
    }
  }
  
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return isPrimary.count - 1
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "numbers", for: indexPath) as! NumberCell
    cell.setup(num: isPrimary[indexPath.row + 1].value, isPrimary: isPrimary[indexPath.row + 1].primary)
    return cell
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    var width = CGFloat(0.0)

    if isPrimary[indexPath.row + 1].value < 10000 {
      width = collectionView.frame.size.width / 10
    }
    else {
      width = collectionView.frame.size.width / 5
  
    }
    return CGSize(width: width, height: width)
  }
}

