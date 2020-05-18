
//
//  UpdatableDrawingClassifier+Extension.swift
//  WWDC2020
//
//  Created by Alexandru Turcanu on 06/05/2020.
//  Copyright © 2020 CodingBytes. All rights reserved.
//

import CoreML

extension UpdatableDrawingClassifier {
    
    // MARK: - Type Helpers
    
    static let unknownLabel = "unknown"
    
    static func updateModel(at url: URL,
                            with trainingData: MLBatchProvider,
                            completionHandler: @escaping (MLUpdateContext) -> ()) {
        
        guard let updateTask = try? MLUpdateTask(
            forModelAt: url,
            trainingData: trainingData,
            configuration: nil,
            completionHandler: completionHandler
            ) else {
                fatalError("Could not update model")
        }
        
        updateTask.resume()
    }
    
    
    // MARK: - Instance Helpers
    
    // helper image constraint based on the model's description
    var imageConstraint: MLImageConstraint {
        let inputName = "drawing"
        
        guard let imageInputDescription = model.modelDescription.inputDescriptionsByName[inputName],
            let imageConstraint = imageInputDescription.imageConstraint else {
                fatalError("Could not retrieve image constraint from model")
        }
        
        return imageConstraint
    }
    
    func predictLabel(for value: MLFeatureValue) -> String? {
        guard let pixelBuffer = value.imageBufferValue else {
            fatalError("Could not get pixel buffer from the image feature value")
        }
        
        // check if the model has been trained to recognize the image
        guard let prediction = try? prediction(drawing: pixelBuffer).label,
            prediction != UpdatableDrawingClassifier.unknownLabel else {
                return nil
        }
        
        return prediction
    }
}
