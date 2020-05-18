
//
//  Text+Extension.swift
//  WWDC2020
//
//  Created by Alexandru Turcanu on 10/05/2020.
//  Copyright © 2020 CodingBytes. All rights reserved.
//

import SwiftUI

public extension Text {
    public func titleStyle() -> some View {
        self
            .font(.largeTitle)
            .fontWeight(.semibold)
            .multilineTextAlignment(.center)
            .transition(.drop)
    }
    
    public func subtitleStyle() -> some View {
        self
            .font(.title)
            .fontWeight(.medium)
            .transition(.opacity)
    }
}
