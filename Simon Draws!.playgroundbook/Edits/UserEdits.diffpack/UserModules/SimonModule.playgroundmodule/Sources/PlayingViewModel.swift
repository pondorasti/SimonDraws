
//
//  PlayingViewModel.swift
//  WWDC2020
//
//  Created by Alexandru Turcanu on 10/05/2020.
//  Copyright © 2020 CodingBytes. All rights reserved.
//

import SwiftUI
import Combine
import AVFoundation
import UtilitiesModule
import MLModule

class PlayingViewModel: ObservableObject {
    
    // MARK: - Properties
    
    var guessingIcons = Simon.Theme.tools.guessingIcons()
    
    private(set) var currentRound = 0
    private(set) var currentIndex = 0
    private(set) var iconSequence = [GuessingIcon]()
    private(set) var preparingToFinishGame = false
    private(set) var timer: Publishers.Autoconnect<Timer.TimerPublisher>?
    
    private var answers = [Bool]()
    private var recognizedDrawingLabel = ""
    private var audioPlayer: AVAudioPlayer?
    
    var state = Simon.PlayingState.speakDialog {
        didSet {
            updatePlayingState()
        }
    }
    
    
    // MARK: - Computed Properties
    
    var currentIcon: GuessingIcon {
        iconSequence[currentIndex]
    }
    
    var numberOfIcons: Int {
        currentRound + 2
    }
    
    var currentDialog: [String] {
        Simon.playingDialogs[currentRound]
    }
    
    
    // MARK: - Initialization
    
    init() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didDraw),
                                               name: .newDrawing,
                                               object: nil
        )
    }
    
    
    // MARK: - Public Methods
    
    func iconColor(for index: Int) -> Color {
        if answers[index] {
            return Color(UIColor.systemGreen)
        } else {
            return Color(UIColor.systemRed)
        }
    }
    
    // Show sequence of randomized icons
    func showNextIcon() {
        guard state == .showIconSequence else {
            return
        }
        
        if currentIndex + 1 < numberOfIcons { // proceed to next icon
            audioPlayer = AVAudioPlayer.autoPlaySound(for: .woosh)
            currentIndex += 1
            updateChanges()
        } else { // finished showing all icons, go to next stage
            audioPlayer = AVAudioPlayer.autoPlaySound(for: .snap)
            state = .getReady
        }
    }
    
    
    // MARK: - Private Methods
    
    @objc private func didDraw(_ notification: Notification) {
        guard let drawing = notification.object as? DrawingModel else {
            fatalError("Invalid notification object")
        }
        
        if state == .playing, !preparingToFinishGame {
            // check if it should add new drawing
            guard currentIndex + 1 <= numberOfIcons else {
                return
            }
            currentIndex += 1
            
            
            let isCorrectDrawing: Bool
            if let drawingLabel = ModelUpdater.predictLabel(for: drawing.featureValue) { // Recognized drawing
                NotificationCenter.default.post(name: .drawingHeadlineUpdate, object: "Recognized: " + drawingLabel)
                isCorrectDrawing = (iconSequence[currentIndex - 1].label == drawingLabel)
            } else { // Model could not predict a label for this drawing
                NotificationCenter.default.post(name: .drawingHeadlineUpdate, object: "Recognized: Nothing")
                isCorrectDrawing = false
            }
            
            answers.append(isCorrectDrawing)
            if !isCorrectDrawing { // stop game - wrong drawing
                finishGame(with: isCorrectDrawing)
            } else if currentIndex == numberOfIcons { // check if drawn all icons
                if currentRound == Simon.numberOfRounds - 1 { // finish game if all rounds completed
                    finishGame(with: isCorrectDrawing)
                } else { // proceed to next round
                    audioPlayer = AVAudioPlayer.autoPlaySound(for: .success)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.currentRound += 1
                        self.state = .speakDialog
                        self.updateChanges()
                    }
                }
            } else {
                audioPlayer = AVAudioPlayer.autoPlaySound(for: .success)
            }
            
            updateChanges()
        }
    }
    
    private func finishGame(with success: Bool) {
        preparingToFinishGame = true
        audioPlayer = AVAudioPlayer.autoPlaySound(for: success ? .wow : .ohNo)
        
        NotificationCenter.default.post(name: .toggleSymbolsOverlay, object: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.gameOverTransitionDuration) {
            self.state = .gameOver
            self.currentRound += (success ? 1 : 0)
        }
    }
    
    private func updatePlayingState() {
        switch state {
        case .speakDialog:
            NotificationCenter.default.post(name: .drawingHeadlineUpdate, object: "Drawing Canvas")
        case .showIconSequence:
            // reset properties
            currentIndex = 0
            answers.removeAll()
            
            // randomize icons
            iconSequence.removeAll()
            while iconSequence.count < numberOfIcons {
                iconSequence = iconSequence + guessingIcons
            }
            iconSequence = Array(iconSequence.shuffled().prefix(numberOfIcons))
            
            
            timer = Timer.publish(every: 1.5, on: .main, in: .common).autoconnect()
            audioPlayer = AVAudioPlayer.autoPlaySound(for: .woosh)
            
        case .playing:
            currentIndex = 0
            timer?.upstream.connect().cancel()
            NotificationCenter.default.post(name: .drawingHeadlineUpdate, object: "Start drawing!")
            
        case .gameOver:
            DispatchQueue.main.asyncAfter(deadline: .now() + Constants.gameOverTransitionDuration) {
                self.currentRound = 0
                self.preparingToFinishGame = false
            }
            
        default:
            break
        }
        
        updateChanges()
    }
    
    // update object changes with an animation
    private func updateChanges() {
        withAnimation(.default) {
            objectWillChange.send()
        }
    }
}
