
//
//  IconModifier.swift
//  WWDC2020
//
//  Created by Alexandru Turcanu on 08/05/2020.
//  Copyright © 2020 CodingBytes. All rights reserved.
//

import SwiftUI

public extension Image {
    public func iconModifier(backgroundColor: Color = Color(UIColor.systemBlue)) -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: .fit)
            
            .frame(size: Constants.iconSize)
            .foregroundColor(.white)
            
            .frame(size: Constants.iconFrameSize)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .foregroundColor(backgroundColor)
        )
    }
}

extension View {
    public func frame(size: CGSize) -> some View {
        self.frame(width: size.width, height: size.height)
    }
}
