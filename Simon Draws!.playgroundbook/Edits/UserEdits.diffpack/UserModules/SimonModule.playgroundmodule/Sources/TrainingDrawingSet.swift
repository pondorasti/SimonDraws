

//
//  TrainingDrawingSet.swift
//  WWDC2020
//
//  Created by Alexandru Turcanu on 07/05/2020.
//  Copyright © 2020 CodingBytes. All rights reserved.
//

import CoreML
import MLModule
import UtilitiesModule

struct TrainingDrawingSet {
    
    // MARK: - Properties
    
    private var trainingDrawings = [DrawingModel]()
    private let answer: String
    
    
    // MARK: - Computed Properties
    
    var isReadyForTraining: Bool {
        trainingDrawings.count == Simon.requiredTrainingData
    }
    
    var count: Int {
        trainingDrawings.count
    }
    
    var featureBatchProvider: MLBatchProvider {
        var featureProviders = [MLFeatureProvider]()
        
        let inputName = "drawing"
        let outputName = "label"
        
        for drawing in trainingDrawings {
            let inputValue = drawing.featureValue
            let outputValue = MLFeatureValue(string: answer)
            
            let dataPointFeatures: [String: MLFeatureValue] = [
                inputName: inputValue,
                outputName: outputValue
            ]
            
            if let provider = try? MLDictionaryFeatureProvider(dictionary: dataPointFeatures) {
                featureProviders.append(provider)
            }
        }
        
        return MLArrayBatchProvider(array: featureProviders)
    }
    
    
    // MARK: - Initialization
    
    init(for answer: String) {
        self.answer = answer
    }
    
    
    // MARK: - Public Methods
    
    mutating func addDrawing(_ drawing: DrawingModel) {
        if trainingDrawings.count < Simon.requiredTrainingData {
            trainingDrawings.append(drawing)
        }
    }
}
