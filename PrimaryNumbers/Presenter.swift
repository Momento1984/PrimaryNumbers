//
//  Presenter.swift
//  PrimaryNumbers
//
//  Created by Виталий Антипов on 19.09.17.
//  Copyright © 2017 Виталий Антипов. All rights reserved.
//
import Foundation

class Presenter {

	private var primary: Primary?

	var numbers: ArraySlice<Int> = []

	private var minIndex = 0
	private var maxIndex = 0

	func getCorrectSearchNumber(text: String) throws -> Int {
		let number = try getCorrectNumber(text: text)

		guard let primary = primary else {
			throw NumbersError.primaryNotExist
		}

		if number > primary.num {
			throw NumbersError.tooBig(num: number)
		}
		return number
	}

	func getCorrectNumber(text: String) throws -> Int {
		guard let number = Int(text), number > 0 else {
			throw NumbersError.incorrectValue
		}
		return number
	}

	func calc(min: Int, max: Int, onProgress: @escaping (Float) -> (), completion: @escaping () -> ()) {
		if let primary = primary, primary.num > max {
			maxIndex = index(of: max).0
			numbers = primary.numbers.dropLast(primary.numbers.count - maxIndex)

			minIndex = index(of: min).0
			numbers = numbers.dropFirst(minIndex)

			completion()
		
		} else {
			DispatchQueue.global(qos: .userInitiated).async { [unowned self] in
				self.primary = Primary(num: max, onProgress: onProgress)
				_ = self.primary!.calcAll()
				
				self.minIndex = self.index(of: min).0
				self.numbers = self.primary!.numbers.dropFirst(self.minIndex)
				
				completion()
			}
		}
	}

	func cleanPrimary() {
		numbers = []
	}

	var countNumbers: Int {
		return numbers.count
	}

	func index(of number: Int) -> (Int, Int?) {
		return primary!.index(of: number)
	}

	func number(at index: Int) -> Int? {
		if index < countNumbers {
			return numbers[minIndex + index]
		} else {
			return nil
		}
	}
}
