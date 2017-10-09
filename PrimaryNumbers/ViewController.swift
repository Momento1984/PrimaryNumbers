//
//  ViewController.swift
//  PrimaryNumbers
//
//  Created by Виталий Антипов on 03.08.17.
//  Copyright © 2017 Виталий Антипов. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate {
  
  @IBOutlet var collectionView: UICollectionView!
  @IBOutlet var searchBar: UISearchBar!
  @IBOutlet var calculateLbl: UILabel!
  @IBOutlet var progressView: UIProgressView!
  @IBOutlet var rangedSlider: RangedSlider!
  
  fileprivate let presenter = Presenter()
  
  fileprivate var findedIndex: Int? {
    didSet {
      
      let newIndexPath = IndexPath(row: findedIndex!, section: 0)
      if let index = oldValue {
        collectionView.reloadItems(at: [IndexPath(row: index, section: 0), newIndexPath])
      } else {
        collectionView.reloadItems(at: [newIndexPath])
      }
    }
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupUI()
  }
  
  func setupUI() {
    collectionView.dataSource = self
    collectionView.delegate = self
    searchBar.delegate = self
    searchBar.layer.borderColor = UIColor.white.cgColor
    //numTxtField.delegate = self
    collectionView.layer.cornerRadius = 5
    hideProgress()
    
    let rangedSliderView = RangedSlider.create()
		rangedSliderView.valuesChangedCallback = valuesChanged
		rangedSliderView.frame = rangedSlider.bounds
    rangedSlider.addSubview(rangedSliderView)
		
  }
  
  private func hideProgress() {
    calculateLbl.isHidden = true
    progressView.isHidden = true
  }
  
  private func showProgress() {
    calculateLbl.isHidden = false
    progressView.isHidden = false
    progressView.progress = 0
  }
  
  private func onProgress(value: Float) {
    DispatchQueue.main.async { [unowned self] in
      self.progressView.setProgress(value, animated: true)
    }
  }
	
	private func valuesChanged(min: Int, max: Int) {
		calc(min: min, max: max)
	}
  
	private func calc(min: Int, max: Int) {
    
    self.view.endEditing(true)

    ErrorHandler.try { [unowned self] in
      self.cleanCollectionView()
      self.showProgress()
      self.collectionView.isUserInteractionEnabled = false
			self.presenter.calc(min: min, max: max, onProgress: self.onProgress, completion: {
        DispatchQueue.main.async {
          self.collectionView.reloadData()
          self.collectionView.isUserInteractionEnabled = true
          self.hideProgress()
        }
      })
    }
    
  }
  
  private func cleanCollectionView() {
    presenter.cleanPrimary()
    self.collectionView.reloadData()
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return presenter.countNumbers
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "numbers", for: indexPath) as! NumberCell
    
    if let number = presenter.number(at: indexPath.row) {
      cell.setup(num: number)
    }
    return cell
  }
  
}

extension ViewController: UISearchBarDelegate {
  
  
  func searchBar(_: UISearchBar, textDidChange: String) {
    ErrorHandler.try {
      let number = try presenter.getCorrectSearchNumber(text: textDidChange)
      findNumber(number)
    }
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
  }
  
  private func findNumber(_ number: Int) {
    collectionView.allowsMultipleSelection = false
		guard let (firstIndex, secondIndex) = presenter.index(of: number) else {
			return
		}
    selectCell(at: firstIndex)
    if let secondIndex = secondIndex {
      collectionView.allowsMultipleSelection = true
      selectCell(at: secondIndex)
    }
  }
  
  private func selectCell(at index: Int) {
    let indexPath = IndexPath(row: index, section: 0)
    collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)
  }
  
}
