
//
//  CGRect+Extension.swift
//  WWDC2020
//
//  Created by Alexandru Turcanu on 07/05/2020.
//  Copyright © 2020 CodingBytes. All rights reserved.
//

import CoreGraphics

public extension CGRect {
    public var containingSquare: CGRect {
        let sideLength = max(width, height)
        
        let xInset = (width - sideLength) / 2
        let yInset = (height - sideLength) / 2
        
        return insetBy(dx: xInset, dy: yInset)
    }
}
