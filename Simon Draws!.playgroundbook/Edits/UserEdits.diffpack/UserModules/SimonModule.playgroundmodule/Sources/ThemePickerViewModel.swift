
//
//  ThemePickerViewModel.swift
//  WWDC2020
//
//  Created by Alexandru Turcanu on 10/05/2020.
//  Copyright © 2020 CodingBytes. All rights reserved.
//

import SwiftUI
import AVFoundation

class ThemePickerViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Binding private var gameState: Simon.State
    @Binding private var guessingIcons: [GuessingIcon]
    
    private(set) var selectedIcons = Simon.Theme.nature.guessingIcons()
    private(set) var isRandomizing = false {
        didSet {
            // update properties prior to randomization start
            updatesCount = 0
            audioPlayer = AVAudioPlayer.autoPlaySound(for: .cardsShuffling)
            audioPlayer?.numberOfLoops = 5
        }
    }
    
    private var isReadyToTrain = false
    private var selectedTheme = Simon.Theme.nature
    private var audioPlayer: AVAudioPlayer?
    
    // jenky elapsedTime, as long as I don't need something fancier this will do the job just fine
    private var updatesCount = 0
    let timer = Timer.publish(every: 0.3, on: .main, in: .common).autoconnect()
    
    
    // MARK: - Computed Properties
    
    var title: String {
        if isReadyToTrain {
            return "Now it's time to show me how you draw!"
        } else if isRandomizing {
            return "Randomizing Icons"
        } else {
            return "Choose your preferred theme"
        }
    }
    
    var selectedThemeName: String {
        selectedTheme.rawValue
    }
    
    
    // MARK: - Initialization
    
    init(guessingIcons: Binding<[GuessingIcon]>, gameState: Binding<Simon.State>) {
        self._gameState = gameState
        self._guessingIcons = guessingIcons
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didDraw),
                                               name: .newDrawing,
                                               object: nil
        )
    }
    
    
    // MARK: - Public Methods
    
    // present next theme
    func next() {
        selectedTheme.next()
        selectedIcons = selectedTheme.guessingIcons(shuffled: false)
        audioPlayer = AVAudioPlayer.autoPlaySound(for: .woosh)
        
        objectWillChange.send()
    }
    
    // present previous theme
    func previous() {
        selectedTheme.previous()
        selectedIcons = selectedTheme.guessingIcons(shuffled: false)
        audioPlayer = AVAudioPlayer.autoPlaySound(for: .woosh)
        
        objectWillChange.send()
    }
    
    func handleScreenUpdate() {
        updatesCount += 1
        
        if isRandomizing { // start randomization
            if updatesCount < 30 { // keep randomizing until a certain upper bound is met
                selectedIcons = selectedTheme.guessingIcons(shuffled: true)
            } else { // notify the user that randomization is done and let him proceed whenever ready
                guessingIcons = self.selectedIcons
                isReadyToTrain = true
                audioPlayer?.stop()
                
                timer.upstream.connect().cancel()
                NotificationCenter.default.post(name: .drawingHeadlineUpdate, object: "Drawing Canvas")
                
                DispatchQueue.main.asyncAfter(deadline: .now() + Simon.dialogDuration) {
                    withAnimation(.default) {
                        self.gameState = .training
                    }
                }
            }
            
            // update object with animation
            withAnimation(.default) {
                objectWillChange.send()
            }
        } else if updatesCount == 1 {
            // update drawing headline when the view appears
            NotificationCenter.default.post(name: .drawingHeadlineUpdate, object: "Draw to choose")
        }
    }
    
    
    // MARK: - Private Methods
    
    @objc private func didDraw(_ notification: Notification) {
        if !isRandomizing { // start randomization if it didn't happen yet
            withAnimation(.default) {
                isRandomizing = true
            }
            
            NotificationCenter.default.post(name: .drawingHeadlineUpdate, object: "Drawing Canvas")
        }
    }
}
