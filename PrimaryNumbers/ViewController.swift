//
//  ViewController.swift
//  PrimaryNumbers
//
//  Created by Виталий Антипов on 03.08.17.
//  Copyright © 2017 Виталий Антипов. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {

  @IBOutlet var collectionView: UICollectionView!
  @IBOutlet var numLbl: UITextField!
  @IBOutlet var searchBar: UISearchBar!
	@IBOutlet var calculateLbl: UILabel!
	@IBOutlet var progressView: UIProgressView!
  
	fileprivate var primary: Primary!
	
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

  @IBAction func calc(_ sender: Any) {
    self.view.endEditing(true)
		guard let text = numLbl.text, let number = getCorrectNumber(text: text) else {
			return
		}
		showProgress()
		collectionView.isUserInteractionEnabled = false
		//_ = primary.calcNext(count: 10000)
		DispatchQueue.global(qos: .userInitiated).async { [unowned self] in
			self.primary = Primary(num: number, onProgress: self.onProgress)
			_ = self.primary.calcAll()
			DispatchQueue.main.async { [unowned self] in
				self.collectionView.reloadData()
				self.collectionView.isUserInteractionEnabled = true
				self.hideProgress()
			}
		}
		
  }
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		calc(self)
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
  
	fileprivate func calcNext(count: Int) {
		let startIndex = primary.numbers.count
    let newNumbers = primary.calcNext(count: count)
    let indexPaths = (startIndex..<startIndex + newNumbers.count).map { IndexPath(row: $0, section: 0) }

    collectionView.insertItems(at: indexPaths)
  }
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return primary?.numbers.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "numbers", for: indexPath) as! NumberCell
		
		cell.setup(num: primary.numbers[indexPath.row], selected: isFinded(index: indexPath.row))
    return cell
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    var width = CGFloat(0.0)

    if primary.numbers[indexPath.row] < 10000 {
      width = collectionView.frame.size.width / 10
    }
    else {
      width = collectionView.frame.size.width / 5
  
    }
    return CGSize(width: width, height: width)
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    /*guard let indexPath = collectionView.indexPathForItem(at: CGPoint(x: 20, y: scrollView.contentOffset.y)) else {
      return
    }
    if primary.hasNext && (indexPath.row > (primary.numbers.count * 3 / 4)) {
			calcNext(count: 10000)
    }*/
    
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
		if number > primary.num {
			errorAlert(title: "Поиск", message: "Число \(searchBar.text!) выходит за пределы рассчитанных")
			return
		}
		guard let index = primary.index(of: number) else {
			errorAlert(title: "Поиск", message: "Число \(searchBar.text!) составное")
			return
		}
		let indexPath = IndexPath(row: index, section: 0)
		findedIndex = index

    collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)

	
  }
	
	func searchIndex(number: Int) -> Int? {
		guard let last = primary.numbers.last else {
			return nil
		}
		if primary.hasNext {
			calcNext(count: 10000)
		}
		return primary.index(of: number)
		
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
}
