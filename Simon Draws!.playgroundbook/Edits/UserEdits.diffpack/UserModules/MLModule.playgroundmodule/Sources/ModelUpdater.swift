//
//  ModelUpdater.swift
//  WWDC2020
//
//  Created by Alexandru Turcanu on 07/05/2020.
//  Copyright © 2020 CodingBytes. All rights reserved.
//

import CoreML

public struct ModelUpdater {
    
    // MARK: - Type Properties
    
    private static var updatedDrawingClassifier: UpdatableDrawingClassifier?
    private static var defaultDrawingClassifier: UpdatableDrawingClassifier {
        guard let model = try? UpdatableDrawingClassifier(contentsOf: defaultModelURL) else {
            fatalError("Could not retrieve default model")
        }
        
        return model
    }
    
    private static var latestModel: UpdatableDrawingClassifier {
        updatedDrawingClassifier ?? defaultDrawingClassifier
    }
    
    
    private static var defaultModelURL: URL {
        guard let url = try? MLModel.compileModel(at: #fileLiteral(resourceName: "UpdatableDrawingClassifier.mlmodel")) else {
            fatalError("Could not retrieve default model")
            
        }
        
        return url
    }
    
    private static var updatedModelURL = appDirectory.appendingPathComponent("personalized.mlmodelc")
    private static var temporaryUpdatedModelURL = appDirectory.appendingPathComponent("personalized_tmp.mlmodelc")
    private static var appDirectory: URL {
        guard let url = FileManager.default.urls(for: .applicationSupportDirectory,
                                                 in: .userDomainMask).first else {
                                                    fatalError("Could not retrieve app directory of the model")
        }
        
        return url
    }
    
    private static var hasMadeFirstPrediction = false
    
    public static var imageConstraint: MLImageConstraint {
        latestModel.imageConstraint
    }
    
    
    // MARK: - Initialization
    
    private init() { }
    
    
    // MARK: - Public Type Methods
    
    public static func predictLabel(for value: MLFeatureValue) -> String? {
        if !hasMadeFirstPrediction {
            hasMadeFirstPrediction = true
            
            loadUpdatedModel()
        }
        
        return latestModel.predictLabel(for: value)
    }
    
    public static func update(with trainingData: MLBatchProvider,
                       completionHandler: @escaping () -> ()) {
        let currentModelURL: URL
        if let _ = updatedDrawingClassifier {
            currentModelURL = updatedModelURL
        } else {
            currentModelURL = defaultModelURL
        }
        
        func updateModelCompletion(updateContext: MLUpdateContext) {
            saveUpdatedModel(updateContext)
            loadUpdatedModel()
            
            DispatchQueue.main.async { completionHandler() }
        }
        
        UpdatableDrawingClassifier.updateModel(
            at: currentModelURL,
            with: trainingData,
            completionHandler: updateModelCompletion
        )
    }
    
    public static func resetDrawingClassifier() {
        updatedDrawingClassifier = nil
        
        if FileManager.default.fileExists(atPath: updatedModelURL.path) {
            try? FileManager.default.removeItem(at: updatedModelURL)
        }
    }
    
    
    // MARK: - Private Type Methods
    
    private static func saveUpdatedModel(_ updateContext: MLUpdateContext) {
        let updatedModel = updateContext.model
        let fileManager = FileManager.default
        
        do {
            try fileManager.createDirectory(at: temporaryUpdatedModelURL,
                                            withIntermediateDirectories: true,
                                            attributes: nil)
            
            try updatedModel.write(to: temporaryUpdatedModelURL)
            
            _ = try fileManager.replaceItemAt(updatedModelURL,
                                              withItemAt: temporaryUpdatedModelURL)
            
            print("Updated model saved")
        } catch let error {
            print("Could not save updated model to the file system")
            return
        }
    }
    
    private static func loadUpdatedModel() {
        guard FileManager.default.fileExists(atPath: updatedModelURL.path),
            let model = try? UpdatableDrawingClassifier(contentsOf: updatedModelURL) else {
                print("Could not retrieve updated model")
                return
        }
        
        updatedDrawingClassifier = model
    }
}
