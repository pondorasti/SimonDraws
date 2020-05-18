
//
//  DrawingView.swift
//  WWDC2020
//
//  Created by Alexandru Turcanu on 09/05/2020.
//  Copyright © 2020 CodingBytes. All rights reserved.
//

import SwiftUI
import UtilitiesModule

struct DrawingView: View {
    
    // MARK: - Properties
    
    @ObservedObject var drawingHeadline: DrawingHeadline
    @State private var drawingOpacity = 1.0
    
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 4) {
            Text(drawingHeadline.value)
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 4)
                .padding(.all, 8)
                .transition(.opacity)
                .id("Drawing Headline ID:" + drawingHeadline.value)
            
            Divider()
            
            DrawingCanvas(opacity: $drawingOpacity.animation(.linear(duration: Constants.drawingFadeDuration)))
                .opacity(drawingOpacity)
        }
        .backgroundModifier(hasPadding: false)
    }
}
