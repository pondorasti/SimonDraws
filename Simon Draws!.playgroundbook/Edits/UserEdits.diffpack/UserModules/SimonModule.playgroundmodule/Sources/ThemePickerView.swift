
//
//  ThemePickerView.swift
//  WWDC2020
//
//  Created by Alexandru Turcanu on 09/05/2020.
//  Copyright © 2020 CodingBytes. All rights reserved.
//

import SwiftUI
import AVFoundation
import UtilitiesModule

struct ThemePickerView: View {
    
    // MARK: - Properties
    
    @ObservedObject var themePickerViewModel: ThemePickerViewModel
    @State private var reversedTransition = false
    
    
    // MARK: - Body
    
    var body: some View {
        Group {
            Text(themePickerViewModel.title)
                .titleStyle()
                .id("Theme Title ID:" + themePickerViewModel.title)
            
            Divider().padding(.horizontal, -24.0)
            
            Text("\(themePickerViewModel.selectedThemeName)")
                .subtitleStyle()
                .id("Theme Name ID:" + themePickerViewModel.selectedThemeName)
            
            HStack(spacing: Constants.generalStackSpacing) {
                // Leading Button
                if !themePickerViewModel.isRandomizing {
                    ThemePickerButton(leadingButton: true) {
                        withAnimation(.default) {
                            self.reversedTransition = true
                            self.themePickerViewModel.previous()
                        }
                    }
                }
                
                ForEach(themePickerViewModel.selectedIcons) { icon in
                    icon.image
                        .iconModifier()
                }
                .transition(themePickerViewModel.isRandomizing
                    ? .verticalSlide
                    : !reversedTransition ? .reversedHorizontalSlide : .horizontalSlide
                )
                    .onReceive(themePickerViewModel.timer) { _ in
                        self.themePickerViewModel.handleScreenUpdate()
                }
                
                // Trailing Button
                if !themePickerViewModel.isRandomizing {
                    ThemePickerButton(leadingButton: false) {
                        withAnimation(.default) {
                            self.reversedTransition = false
                            self.themePickerViewModel.next()
                        }
                        
                    }
                }
            }
        }
    }
}
