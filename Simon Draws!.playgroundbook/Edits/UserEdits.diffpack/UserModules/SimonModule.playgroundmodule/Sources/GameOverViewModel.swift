
//
//  GameOverViewModel.swift
//  WWDC2020
//
//  Created by Alexandru Turcanu on 12/05/2020.
//  Copyright © 2020 CodingBytes. All rights reserved.
//

import SwiftUI
import AVFoundation

class GameOverViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Binding private var playingState: Simon.PlayingState
    
    private let numberOfRounds: Int
    private var audioPlayer: AVAudioPlayer?
    
    
    // MARK: - Computed Properties
    
    var title: String {
        winState
            ? "Well done 👏 ! You win 🥳 !"
            : "Game over! Better luck next time 😉"
    }
    
    var subtitle: String {
        "Your score is \(numberOfRounds + (winState ? 1 : 0))!"
    }
    
    var winState: Bool {
        Simon.numberOfRounds == numberOfRounds
    }
    
    
    // MARK: - Initialization
    
    init(playingState: Binding<Simon.PlayingState>, numberOfRounds: Int) {
        self._playingState = playingState
        self.numberOfRounds = numberOfRounds
        
        NotificationCenter.default.post(name: .drawingHeadlineUpdate,
                                        object: winState ? "Draw to play again" : " Draw to try again"
        )
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didDraw),
                                               name: .newDrawing,
                                               object: nil
        )
    }
    
    // MARK: - Private Methods
    
    @objc private func didDraw() {
        guard playingState == .gameOver else {
            return
        }
        
        withAnimation(.default) {
            playingState = .speakDialog
        }
        
        NotificationCenter.default.post(name: .toggleSymbolsOverlay, object: nil)
    }
}
