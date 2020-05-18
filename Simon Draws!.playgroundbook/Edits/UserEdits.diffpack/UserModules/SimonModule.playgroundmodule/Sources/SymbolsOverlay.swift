

//
//  SymbolsOverlay.swift
//  WWDC2020
//
//  Created by Alexandru Turcanu on 14/05/2020.
//  Copyright © 2020 CodingBytes. All rights reserved.
//

import SwiftUI
import UIKit
import UtilitiesModule

struct SymbolsOverlay: UIViewRepresentable {
    
    // MARK: - Properties
    
    @ObservedObject private var symbolsOverlayViewModel: SymbolsOverlayViewModel
    
    private let geometry: GeometryProxy
    private let symbols: [GuessingIcon]
    private let particleEmitter: CAEmitterLayer
    private let foregroundColor = UIColor.secondaryLabel
    
    
    // MARK: - Initialization
    
    init(symbolsOverlayViewModel: SymbolsOverlayViewModel, geometry: GeometryProxy, symbols: [GuessingIcon]) {
        self.symbolsOverlayViewModel = symbolsOverlayViewModel
        self.geometry = geometry
        self.symbols = symbols
        
        particleEmitter = CAEmitterLayer()
    }
    
    
    // MARK: - Lifecycle
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        return view
    }
    
    
    func updateUIView(_ uiView: UIView, context: Context) {
        if symbolsOverlayViewModel.show {
            setUpParticleEmitter(in: uiView)
            //            particleEmitter.birthRate = 1
            particleEmitter.emitterCells = createSymbolEmitters()
        } else {
            particleEmitter.birthRate = 0
        }
        
        UIView.animate(withDuration: Constants.gameOverTransitionDuration) {
            uiView.layer.opacity = (self.symbolsOverlayViewModel.show ? 1 : 0)
        }
    }
    
    
    // MARK: - Private Methods
    
    private func setUpParticleEmitter(in view: UIView) {
        particleEmitter.removeFromSuperlayer()
        particleEmitter.emitterCells?.removeAll()
        
        particleEmitter.emitterPosition = CGPoint(x: geometry.size.width / 2, y: -300)
        particleEmitter.emitterShape = CAEmitterLayerEmitterShape.line
        particleEmitter.emitterSize = CGSize(width: geometry.size.width, height: 20)
        particleEmitter.birthRate = 1
        
        view.layer.sublayers?.removeAll()
        view.layer.addSublayer(particleEmitter)
    }
    
    private func createSymbolEmitters() -> [CAEmitterCell] {
        var symbolEmitters = [CAEmitterCell]()
        for symbol in symbols {
            let symbolParticle = CAEmitterCell()
            
            symbolParticle.birthRate = 1.5
            symbolParticle.lifetime = 15
            symbolParticle.lifetimeRange = 5
            
            symbolParticle.velocity = 90
            symbolParticle.velocityRange = 40
            
            symbolParticle.emissionLongitude = CGFloat(Double.pi)
            symbolParticle.emissionRange = 0
            
            symbolParticle.spin = 0.5
            symbolParticle.spinRange = 0.3
            
            symbolParticle.scaleRange = 0.5
            symbolParticle.scaleSpeed = -0.05
            
            
            // Changing rendering and tint of an UIImage doesn't seem to work with the CAEmitterCell
            symbolParticle.contents = UIImage(systemName: symbol.imageName)?
                .tint(with: foregroundColor)?.cgImage
            
            symbolEmitters.append(symbolParticle)
        }
        
        return symbolEmitters
    }
}


// MARK: - UIImage Extension

// Source: https://stackoverflow.com/a/34547445/7897036
fileprivate extension UIImage {
    func tint(with fillColor: UIColor) -> UIImage? {
        let image = withRenderingMode(.alwaysTemplate)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        fillColor.set()
        image.draw(in: CGRect(origin: .zero, size: size))
        
        guard let imageColored = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        
        UIGraphicsEndImageContext()
        return imageColored
    }
}
