
//
//  TrainingView.swift
//  WWDC2020
//
//  Created by Alexandru Turcanu on 08/05/2020.
//  Copyright © 2020 CodingBytes. All rights reserved.
//

import SwiftUI

struct TrainingView: View {
    
    // MARK: - Properties
    
    @ObservedObject var trainingViewModel: TrainingViewModel
    
    
    // MARK: - Body
    
    var body: some View {
        Group {
            Text("Training Simon")
                .titleStyle()
            
            Divider().padding(.horizontal, -24)
            
            Text(trainingViewModel.drawingCountText)
                .subtitleStyle()
                .id("Drawing Count ID: \(trainingViewModel.drawingCountText)")
            
            trainingViewModel.currentIcon.image
                .iconModifier()
                .transition(.verticalSlide)
                .id("Icon ID: \(trainingViewModel.currentIndex)")
        }
    }
}
