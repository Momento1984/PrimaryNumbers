//
//  ViewController.swift
//  PrimaryNumbers
//
//  Created by Виталий Антипов on 03.08.17.
//  Copyright © 2017 Виталий Антипов. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

  @IBOutlet var collectionView: UICollectionView!
  @IBOutlet var numLbl: UITextField!
  @IBOutlet var searchBar: UISearchBar!
  
  
  private var primaryNumbers = [Int]()
  private var primary = Primary(num: 1)
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupUI()
  }
  
  func setupUI() {
    collectionView.dataSource = self
    collectionView.delegate = self
    searchBar.delegate = self
    
    collectionView.layer.cornerRadius = 5

  }

  @IBAction func calc(_ sender: Any) {
    self.view.endEditing(true)
    guard let text = numLbl.text, let number = Int(text) else {
      return
    }
    if number > 1 {
      primary = Primary(num: number)
      primaryNumbers = primary.calcNext()
      collectionView.reloadData()
    }
    
  }
  
  private func calcNext() {
    let newNumbers = primary.calcNext()
    let indexPaths = (primaryNumbers.count..<primaryNumbers.count + newNumbers.count).map { IndexPath(row: $0, section: 0) }
    primaryNumbers += newNumbers

    collectionView.insertItems(at: indexPaths)
  }
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return primaryNumbers.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "numbers", for: indexPath) as! NumberCell
    cell.setup(num: primaryNumbers[indexPath.row])
    return cell
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    var width = CGFloat(0.0)

    if primaryNumbers[indexPath.row] < 10000 {
      width = collectionView.frame.size.width / 10
    }
    else {
      width = collectionView.frame.size.width / 5
  
    }
    return CGSize(width: width, height: width)
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    guard let indexPath = collectionView.indexPathForItem(at: CGPoint(x: 20, y: scrollView.contentOffset.y)) else {
      return
    }
    if primary.hasNext && (indexPath.row > (primary.numbers.count * 3 / 4)) {
      calcNext()
    }
    
  }
}

extension ViewController: UISearchBarDelegate {
  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    collectionView.scrollToItem(at: IndexPath(row: 1000, section: 0), at: .bottom, animated: true)
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
  }
}
