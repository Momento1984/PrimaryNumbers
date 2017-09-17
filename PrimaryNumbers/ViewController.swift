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
  @IBOutlet var numTxtField: UITextField!
  @IBOutlet var searchBar: UISearchBar!
	@IBOutlet var calculateLbl: UILabel!
	@IBOutlet var progressView: UIProgressView!
  
	fileprivate var primary: Primary?
	
	fileprivate var findedIndex: Int? = nil{
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
    numTxtField.delegate = self
    collectionView.layer.cornerRadius = 5
		hideProgress()

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

  func calc(_ sender: Any) {
    self.view.endEditing(true)
		guard let text = numTxtField.text, let number = getCorrectNumber(text: text) else {
			return
		}
    
    cleanCollectionView()
		showProgress()
		collectionView.isUserInteractionEnabled = false
    
    DispatchQueue.global(qos: .userInitiated).async { [unowned self] in
			self.primary = Primary(num: number, onProgress: self.onProgress)
			_ = self.primary!.calcAll()
			DispatchQueue.main.async { [unowned self] in
				self.collectionView.reloadData()
				self.collectionView.isUserInteractionEnabled = true
				self.hideProgress()
			}
		}
  }
  
  private func cleanCollectionView() {
    primary = nil
    self.collectionView.reloadData()
  }
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		calc(self)
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
  
	fileprivate func calcNext(count: Int) {
		let startIndex = primary!.numbers.count
    let newNumbers = primary!.calcNext(count: count)
    let indexPaths = (startIndex..<startIndex + newNumbers.count).map { IndexPath(row: $0, section: 0) }

    collectionView.insertItems(at: indexPaths)
  }
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return primary?.numbers.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    let cell = cell as! NumberCell
    cell.setup(num: primary!.numbers[indexPath.row])
  }
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "numbers", for: indexPath) as! NumberCell
		
		cell.setup(num: primary!.numbers[indexPath.row])
    return cell
  }

  func errorAlert(title: String, message: String) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Закрыть", style: .cancel, handler: nil))
		present(alert, animated: true, completion: nil)

	}
	
	func isFinded(index: Int) -> Bool {
		if let finded = findedIndex, index == finded {
			return true
		} else {
			return false
		}
	}

}

extension ViewController: UISearchBarDelegate {
  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
		guard let text = searchBar.text, let number = getCorrectNumber(text: text) else {
			return
		}
    guard let primary = primary else {
      errorAlert(title: "Поиск", message: "Простые числа еще не рассчитаны")
      return
    }
		if number > primary.num {
			errorAlert(title: "Поиск", message: "Число \(searchBar.text!) выходит за пределы рассчитанных")
			return
		}
    findNumber(number)
  }
	
	func getCorrectNumber(text: String) -> Int? {
		guard let number = Int(text), number > 0 else {
			errorAlert(title: "Ошибка", message: "Допустимо только положительное число")
			return nil
		}
		return number
	}
	
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		searchBar.resignFirstResponder()
  }
  
  private func findNumber(_ number: Int) {
    collectionView.allowsMultipleSelection = false
    let (firstIndex, secondIndex) = primary!.index(of: number)
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
