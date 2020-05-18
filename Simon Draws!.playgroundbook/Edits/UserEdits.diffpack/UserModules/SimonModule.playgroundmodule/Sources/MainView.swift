//
//  MainView.swift
//  WWDC2020
//
//  Created by Alexandru Turcanu on 07/05/2020.
//  Copyright © 2020 CodingBytes. All rights reserved.
//

import SwiftUI
import UtilitiesModule

public struct MainView: View {
    
    // MARK: - Properties
    
    private var simonViewModel = SimonViewModel()
    private var playingViewModel = PlayingViewModel()
    private var symbolsOverlayViewModel = SymbolsOverlayViewModel()
    private var drawingHeadline = DrawingHeadline()
    
    
    // MARK: - Initialization
    
    public init() { }
    
    
    // MARK: - Body
    
    public var body: some View {
        ZStack {
            Group {
                // Background
                Color(UIColor.systemGroupedBackground)
                    .edgesIgnoringSafeArea(.all)
                
                // Symbols Overlay
                GeometryReader { geometry in
                    SymbolsOverlay(
                        symbolsOverlayViewModel: self.symbolsOverlayViewModel,
                        geometry: geometry,
                        symbols: self.playingViewModel.guessingIcons
                    )
                }
                
                // Game Views & DrawingCanvas
                GeometryReader { geometry in
                    VStack {
                        SimonView(simonViewModel: self.simonViewModel, playingViewModel: self.playingViewModel)
                        
                        Spacer()
                        
                        DrawingView(drawingHeadline: self.drawingHeadline)
                            .frame(maxWidth: 800)
                            .frame(width: geometry.frame(in: .global).width,
                                   height: min(geometry.frame(in: .global).height * 0.45, 352))
                    }
                }
                .padding(Constants.bigSpacing)
            }
        }
    }
}
