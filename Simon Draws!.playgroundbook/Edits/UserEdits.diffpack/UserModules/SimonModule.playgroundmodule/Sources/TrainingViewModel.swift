
//
//  TrainingViewModel.swift
//  WWDC2020
//
//  Created by Alexandru Turcanu on 10/05/2020.
//  Copyright © 2020 CodingBytes. All rights reserved.
//

import SwiftUI
import AVFoundation
import MLModule

class TrainingViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Binding private var gameState: Simon.State
    
    private(set) var currentIndex = 0
    
    private var guessingIcons: [GuessingIcon]
    private var trainedIcons = 0
    private var drawingSets = [TrainingDrawingSet]()
    private var audioPlayer: AVAudioPlayer?
    
    
    // MARK: - Computed Properties
    
    var currentIcon: GuessingIcon {
        guessingIcons[currentIndex]
    }
    
    private var isReadyForTraining: Bool {
        drawingSets[currentIndex].isReadyForTraining &&
            trainedIcons < guessingIcons.count
    }
    
    private var shouldAddDrawing: Bool {
        if drawingSets.count == Simon.numberOfGuessingIcons {
            if let count = drawingSets.last?.count, count == Simon.requiredTrainingData {
                return false
            }
        }
        return true
    }
    
    var drawingCountText: String {
        if shouldAddDrawing {
            return currentIcon.label + ": Drawing \((drawingSets.last?.count ?? 0) + 1) out of \(Simon.requiredTrainingData)"
        } else {
            return "Processing..."
        }
    }
    
    
    // MARK: - Initialization
    
    init(guessingIcons: [GuessingIcon], gameState: Binding<Simon.State>) {
        self.guessingIcons = guessingIcons
        self._gameState = gameState
        audioPlayer = AVAudioPlayer.autoPlaySound(for: .woosh)
        
        updateDrawingHeadline()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didDraw),
                                               name: .newDrawing,
                                               object: nil
        )
    }
    
    
    // MARK: - Private Methods
    
    @objc private func didDraw(_ notification: Notification) {
        guard let drawing = notification.object as? DrawingModel else {
            fatalError("Invalid notification object")
        }
        
        guard shouldAddDrawing else {
            return
        }
        
        // create training array for first drawing
        if drawingSets.isEmpty {
            drawingSets.append(TrainingDrawingSet(for: guessingIcons[0].label))
        }
        
        // add drawing to current training array
        drawingSets[currentIndex].addDrawing(drawing)
        
        if isReadyForTraining {
            // update core ml model
            DispatchQueue.global(qos: .userInteractive).async {
                ModelUpdater.update(with: self.drawingSets[self.trainedIcons].featureBatchProvider) {
                    self.trainedIcons += 1
                    
                    // continue to next gameState if when updating the model is finished
                    if self.trainedIcons == self.guessingIcons.count {
                        NotificationCenter.default.post(name: .drawingHeadlineUpdate, object: "Drawing Canvas ")
                        withAnimation(.default) {
                            self.gameState = .playing
                        }
                    }
                }
            }
            
            // proceed to next guessing icon if it exists
            if currentIndex + 1 < guessingIcons.count {
                currentIndex += 1
                audioPlayer = AVAudioPlayer.autoPlaySound(for: .woosh)
                updateDrawingHeadline()
                drawingSets.append(TrainingDrawingSet(for: guessingIcons[currentIndex].label))
            }
        }
        
        // refresh view
        withAnimation(.default) {
            objectWillChange.send()
        }
    }
    
    private func updateDrawingHeadline() {
        guard let firstCharacter = currentIcon.label.first else {
            fatalError("Empty training label")
        }
        
        NotificationCenter.default.post(
            name: .drawingHeadlineUpdate,
            object: "Draw " + (firstCharacter.isVowel() ? "an " : "a ") + currentIcon.label
        )
    }
}


// MARK: - Character Extension
fileprivate extension Character {
    func isVowel() -> Bool {
        return ["a", "e", "i", "o", "u"].contains(self.lowercased())
    }
}
