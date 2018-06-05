//
//  Extensions.swift
//  AustinWeather
//
//  Created by Brandon Mahoney on 6/4/18.
//  Copyright © 2018 BrandonMahoney.tech. All rights reserved.
//

import Foundation

// MARK: Extensions
extension Array {
    var shuffle:[Element] {
        var elements = self
        for index in 0..<elements.count {
            let anotherIndex = Int(arc4random_uniform(UInt32(elements.count-index)))+index
            if anotherIndex != index {
                //                swap(&elements[index], &elements[anotherIndex])
                elements.swapAt(index, anotherIndex)
            }
        }
        return elements
    }
}
