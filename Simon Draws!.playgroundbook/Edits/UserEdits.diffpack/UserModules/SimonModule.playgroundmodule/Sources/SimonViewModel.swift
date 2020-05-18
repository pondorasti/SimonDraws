//
//  SimonViewModel.swift
//  WWDC2020
//
//  Created by Alexandru Turcanu on 12/05/2020.
//  Copyright © 2020 CodingBytes. All rights reserved.
//

import SwiftUI

class SimonViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var gameState = Simon.State.introduction
    @Published private(set) var showSimonView = false
    @Published private(set) var showSimonCharacter = false
    
    private var startedGame = false
    
    
    // MARK: - Initialization
    
    init() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didDraw),
                                               name: .newDrawing,
                                               object: nil
        )
    }
    
    
    // MARK: - Private methods
    
    @objc private func didDraw() {
        guard !startedGame else {
            return
        }
        
        startedGame = true
        NotificationCenter.default.post(name: .drawingHeadlineUpdate, object: "Drawing Canvas")
        NotificationCenter.default.post(name: .toggleSymbolsOverlay, object: "Drawing Canvas")
        
        withAnimation(Animation.default.delay(1)) {
            self.showSimonCharacter.toggle()
        }
        // TODO: maybe add a delay to IntroductionView animations based on the 1.5 delay
        withAnimation(Animation.default.delay(1.5)) {
            self.showSimonView.toggle()
        }
    }
}
