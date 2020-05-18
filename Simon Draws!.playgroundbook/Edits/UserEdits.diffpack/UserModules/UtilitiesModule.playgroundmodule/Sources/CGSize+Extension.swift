
//
//  CGSize+Extension.swift
//  WWDC2020
//
//  Created by Alexandru Turcanu on 09/05/2020.
//  Copyright © 2020 CodingBytes. All rights reserved.
//

import CoreGraphics

public extension CGSize {
    public static func *(_ lhs: CGSize, _ rhs: CGFloat) -> CGSize {
        return CGSize(width: lhs.width * rhs, height: lhs.height * rhs)
    }
}
