

//
//  DrawingModel.swift
//  WWDC2020
//
//  Created by Alexandru Turcanu on 06/05/2020.
//  Copyright © 2020 CodingBytes. All rights reserved.
//

import CoreML
import CoreImage
import MLModule

public struct DrawingModel {
    
    // MARK: - Type Properties
    
    private static let ciContext = CIContext()
    
    
    // MARK: - Properties
    
    let image: CGImage
    let rectangle: CGRect
    
    public init(image: CGImage, rectangle: CGRect) {
        self.image = image
        self.rectangle = rectangle
    }
    
    
    // MARK: - Computed Properties
    
    private var whiteTintedImage: CGImage {
        let brightnessParameter = [kCIInputBrightnessKey: 1.0]
        let ciImage = CIImage(cgImage: image)
            .applyingFilter("CIColorControls", parameters: brightnessParameter)
        
        guard let cgImage = DrawingModel.ciContext.createCGImage(ciImage, from: ciImage.extent) else {
            fatalError("Uh oh! Could not create white tinted image.")
        }
        
        return cgImage
    }
    
    public var featureValue: MLFeatureValue {
        let imageConstraint = ModelUpdater.imageConstraint
        if let imageFeatureValue = try? MLFeatureValue(cgImage: whiteTintedImage,
                                                       constraint: imageConstraint) {
            return imageFeatureValue
        } else {
            fatalError("Could not get feature value from Drawing Model")
        }
    }
}
