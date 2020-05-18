
//
//  BackgroundModifier.swift
//  WWDC2020
//
//  Created by Alexandru Turcanu on 07/05/2020.
//  Copyright © 2020 CodingBytes. All rights reserved.
//

import SwiftUI

public extension View {
    public func backgroundModifier(hasPadding: Bool = true) -> some View {
        self
            .frame(maxWidth: .infinity)
            .padding(.all, hasPadding ? 24 : 0)
            .background(Color(UIColor.secondarySystemGroupedBackground))
            .cornerRadius(Constants.cornerRadius)
    }
}
