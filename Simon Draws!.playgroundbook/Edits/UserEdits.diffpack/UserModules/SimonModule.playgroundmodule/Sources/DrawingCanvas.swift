
//
//  DrawingCanvas.swift
//  WWDC2020
//
//  Created by Alexandru Turcanu on 06/05/2020.
//  Copyright © 2020 CodingBytes. All rights reserved.
//

import PencilKit
import SwiftUI
import UIKit
import AVFoundation
import UtilitiesModule
import MLModule

struct DrawingCanvas: UIViewRepresentable {
    
    // MARK: - Properties
    
    @Binding private var opacity: Double
    
    private var dispatchWorker: DispatchWorkItem?
    private var audioPlayer: AVAudioPlayer? = nil
    
    
    // MARK: - Initialization
    
    init(opacity: Binding<Double>) {
        self._opacity = opacity
    }
    
    
    // MARK: - Coordinator
    
    class Coordinator: NSObject, PKCanvasViewDelegate {
        var parent: DrawingCanvas
        init(_ parent: DrawingCanvas) {
            self.parent = parent
        }
        
        
        // MARK: - PKCanvasViewDelegates
        
        // Drawing a new stroke
        func canvasViewDidBeginUsingTool(_ canvasView: PKCanvasView) {
            parent.audioPlayer = AVAudioPlayer.autoPlaySound(for: .pencil)
            parent.dispatchWorker?.cancel()
        }
        
        func canvasViewDidEndUsingTool(_ canvasView: PKCanvasView) {
            parent.audioPlayer?.stop()
        }
        
        // Finished drawing or canvas cleared
        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            let drawingRect = canvasView.drawing.bounds
            
            // make sure the drawing is not empty
            guard drawingRect.size != .zero else {
                return
            }
            
            
            parent.dispatchWorker = DispatchWorkItem(block: {
                self.prepareDrawingForRecognition(canvasView)
            })
            
            DispatchQueue.global(qos: .userInitiated).asyncAfter(
                deadline: .now() + Simon.drawingBuffer,
                execute: parent.dispatchWorker!
            )
        }
        
        
        // MARK: - Private Methods
        
        private func prepareDrawingForRecognition(_ canvasView: PKCanvasView) {
            let drawingRectangle = canvasView.drawing.bounds.containingSquare
            let image = canvasView.drawing.image(
                from: drawingRectangle,
                scale: UIScreen.main.scale * 2
            )
            
            if let cgImage = image.cgImage {
                let drawing = DrawingModel(image: cgImage, rectangle: drawingRectangle)
                
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: .newDrawing, object: drawing)
                }
            } else {
                fatalError("Could not get CGImage from canvas drawing")
            }
            
            resetCanvas(canvasView)
        }
        
        private func resetCanvas(_ canvasView: PKCanvasView) {
            DispatchQueue.main.async {
                canvasView.isUserInteractionEnabled = false
                self.parent.opacity = 0
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + Constants.drawingFadeDuration) {
                canvasView.drawing = PKDrawing()
                canvasView.isUserInteractionEnabled = true
                self.parent.opacity = 1
            }
        }
    }
    
    
    // MARK: - Lifecycle
    
    func makeUIView(context: Context) -> PKCanvasView {
        let canvasView = PKCanvasView()
        
        canvasView.tool = PKInkingTool(.pen, color: .black, width: 15)
        canvasView.backgroundColor = .clear
        canvasView.allowsFingerDrawing = true
        canvasView.isOpaque = false
        
        canvasView.delegate = context.coordinator
        
        return canvasView
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}
