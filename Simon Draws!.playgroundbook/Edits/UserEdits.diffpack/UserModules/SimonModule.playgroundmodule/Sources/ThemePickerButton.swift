
//
//  ThemePickerButton.swift
//  WWDC2020
//
//  Created by Alexandru Turcanu on 10/05/2020.
//  Copyright © 2020 CodingBytes. All rights reserved.
//

import SwiftUI
import UtilitiesModule

struct ThemePickerButton: View {
    
    // MARK: - Properties
    
    private let action: () -> ()
    private let leadingButton: Bool
    
    
    // MARK: - Initialization
    
    init(leadingButton: Bool, action: @escaping () -> ()) {
        self.leadingButton = leadingButton
        self.action = action
    }
    
    
    // MARK: - Body
    
    var body: some View {
        Group {
            if !leadingButton {
                Spacer()
            }
            
            Button(action: action) {
                Image(systemName: leadingButton ? "chevron.left.circle.fill" : "chevron.right.circle.fill")
                    .resizable()
                    .frame(size: Constants.iconSize * 0.85)
                    .background(Circle().foregroundColor(.white).padding(1))
            }
            
            if leadingButton {
                Spacer()
            }
        }
        .transition(.reversedHorizontalSlide)
    }
}
