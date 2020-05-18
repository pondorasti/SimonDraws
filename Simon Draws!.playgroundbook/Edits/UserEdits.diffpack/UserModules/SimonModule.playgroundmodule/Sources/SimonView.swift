//
//  SimonView.swift
//  WWDC2020
//
//  Created by Alexandru Turcanu on 07/05/2020.
//  Copyright © 2020 CodingBytes. All rights reserved.
//

import SwiftUI
import UtilitiesModule

struct SimonView: View {
    
    // MARK: - Properties
    
    @ObservedObject var simonViewModel: SimonViewModel
    @ObservedObject var playingViewModel: PlayingViewModel
    
    
    // MARK: - Body
    
    /// Note to future self
    /// Before you start refactoring this view in order to make it smaller and more manageable,
    /// you should know that transitions start to behave funky in nested child views!
    var body: some View {
        ZStack(alignment: .topLeading) {
            if simonViewModel.showSimonView {
                VStack(spacing: Constants.generalStackSpacing) {
                    if simonViewModel.gameState == .introduction { // 1. Introduction Dialog
                        DialogView(
                            currentState: $simonViewModel.gameState.animation(.default),
                            nextState: .themePicking,
                            dialog: Simon.introductionDialog
                        )
                    } else if simonViewModel.gameState == .themePicking { // 2. Theme Picking
                        ThemePickerView(themePickerViewModel: ThemePickerViewModel(
                            guessingIcons: $playingViewModel.guessingIcons,
                            gameState: $simonViewModel.gameState
                        ))
                    } else if simonViewModel.gameState == .training { // 3. Training Simon
                        TrainingView(trainingViewModel: TrainingViewModel(
                            guessingIcons: playingViewModel.guessingIcons,
                            gameState: $simonViewModel.gameState
                        ))
                    } else if playingViewModel.state == .speakDialog { // 4.1 Playing - Short dialog
                        DialogView(
                            currentState: $playingViewModel.state,
                            nextState: .showIconSequence,
                            dialog: playingViewModel.currentDialog
                        )
                    } else if playingViewModel.state == .showIconSequence { // 4.2 Playing - Randomized icon sequence
                        playingViewModel.currentIcon.image
                            .iconModifier()
                            .transition(.reversedHorizontalSlide)
                            .id("Icon ID: \(playingViewModel.currentIndex)")
                            
                            .onReceive(playingViewModel.timer!) { (_) in
                                self.playingViewModel.showNextIcon()
                        }
                    } else if playingViewModel.state == .getReady { // 4.3 Playing - Ready! Set! Go!
                        DialogView(
                            currentState: $playingViewModel.state,
                            nextState: .playing,
                            dialog: Simon.getReadyDialog,
                            dialogBuffer: Simon.fastDialogDuration
                        )
                    } else if playingViewModel.state == .playing && playingViewModel.currentIndex != 0 { // 4.4 Playing - Actually playing :]
                        HStack(spacing: Constants.generalStackSpacing) {
                            ForEach(0..<playingViewModel.currentIndex, id: \.self) { index in
                                self.playingViewModel.iconSequence[index].image
                                    .iconModifier(backgroundColor: self.playingViewModel.iconColor(for: index))
                                    .transition(.reversedHorizontalSlide)
                                    .id("Icon ID: \(index)")
                            }
                        }
                    } else if playingViewModel.state == .gameOver { // 4.5 Playing - Game Over
                        GameOverView(gameOverViewModel: GameOverViewModel(
                            playingState: $playingViewModel.state,
                            numberOfRounds: playingViewModel.currentRound
                        ))
                    }
                    
                }
                .frame(minHeight: Constants.iconFrameSize.height)
                .backgroundModifier()
                .frame(maxWidth: 504)
                .transition(.opacity)
            }
            
            if simonViewModel.showSimonCharacter {
                Image(systemName: "faceid")
                    .iconModifier(backgroundColor: Color(.systemIndigo))
                    .offset(
                        x: -Constants.iconFrameSize.width / 2,
                        y: -Constants.iconFrameSize.height / 2
                )
                    .transition(.drop)
            }
        }
        .onAppear {
            NotificationCenter.default.post(name: .drawingHeadlineUpdate, object: "Draw to begin")
        }
    }
}
