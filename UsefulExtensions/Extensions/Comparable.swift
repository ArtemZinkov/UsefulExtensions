//
//  Comparable.swift
//  UsefulExtensions
//
//  Created by Artem Zinkov on 24.05.2021.
//  Copyright © 2021 Artem Zinkov. All rights reserved.
//

import Foundation

extension Comparable {

    func clamped(min: Self, max: Self) -> Self {
        if self < min {
            return min
        } else if self > max {
            return max
        }
        return self
    }

    func clamped(in range: ClosedRange<Self>) -> Self {
        return clamped(min: range.lowerBound, max: range.upperBound)
    }
}
