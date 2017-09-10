//
//  Primary.swift
//  PrimaryNumbers
//
//  Created by Виталий Антипов on 04.08.17.
//  Copyright © 2017 Виталий Антипов. All rights reserved.
//
import Foundation
class Primary {
	private(set) var num: Int
	private var offset = 0
	private(set) var numbers = [Int]()
	private var isPrimary = [Bool]()
	private var endPart = 0
	
	private let onProgress: (Float) -> ()
	
	init(num: Int, onProgress: @escaping (Float) -> ()) {
		self.num = num
		self.onProgress = onProgress
	}
	
	var hasNext: Bool {
		return endPart != num
	}
	
	func calcNext(count: Int) -> [Int] {
		endPart = min(offset + count, num)
		isPrimary += [Bool](repeating: true, count: min(count, num - offset))
		let end = Int(sqrt(Double(endPart))) + 1
		for i in 2..<end {
			if isPrimary[i] {
				print(i)
				for k in stride(from: i * i, to: endPart, by: i) {
					isPrimary[k] = false
				}
			}
		}
		
		let partNumbers = isPrimary.dropFirst(offset).indices.flatMap { isPrimary[$0] ? $0 : nil }
		numbers += partNumbers
		offset = endPart
		
		return partNumbers
	}
	
	func calcAll() -> [Int] {
		let end = Int(sqrt(Double(num))) + 1
		isPrimary = [Bool](repeating: true, count: num)
		for i in 2..<end {
			if isPrimary[i] {
				print(i)
				onProgress(Float(i) / Float(end))
				for k in stride(from: i * i, to: num, by: i) {
					isPrimary[k] = false
				}
			}
		}
		
		numbers = isPrimary.dropFirst(2).indices.flatMap { isPrimary[$0] ? $0 : nil }
		
		return numbers
	}
	
	func clear() {
		numbers = []
	}
	
	func index(of number: Int) -> Int? {
		return numbers.index(of: number)
	}
}
