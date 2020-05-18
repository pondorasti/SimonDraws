
//
// UpdatableDrawingClassifier.swift
//
// This file was automatically generated and should not be edited.
//

import CoreML


/// Model Prediction Input Type
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
class UpdatableDrawingClassifierInput : MLFeatureProvider {
    
    /// Input sketch image with black background and white strokes as grayscale (kCVPixelFormatType_OneComponent8) image buffer, 28 pixels wide by 28 pixels high
    var drawing: CVPixelBuffer
    
    var featureNames: Set<String> {
        get {
            return ["drawing"]
        }
    }
    
    func featureValue(for featureName: String) -> MLFeatureValue? {
        if (featureName == "drawing") {
            return MLFeatureValue(pixelBuffer: drawing)
        }
        return nil
    }
    
    init(drawing: CVPixelBuffer) {
        self.drawing = drawing
    }
}

/// Model Prediction Output Type
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
class UpdatableDrawingClassifierOutput : MLFeatureProvider {
    
    /// Source provided by CoreML
    
    private let provider : MLFeatureProvider
    
    
    /// Predicted label. Defaults to 'unknown' as string value
    lazy var label: String = {
        [unowned self] in return self.provider.featureValue(for: "label")!.stringValue
        }()
    
    /// Probabilities / score for each possible label. as dictionary of strings to doubles
    lazy var labelProbs: [String : Double] = {
        [unowned self] in return self.provider.featureValue(for: "labelProbs")!.dictionaryValue as! [String : Double]
        }()
    
    var featureNames: Set<String> {
        return self.provider.featureNames
    }
    
    func featureValue(for featureName: String) -> MLFeatureValue? {
        return self.provider.featureValue(for: featureName)
    }
    
    init(label: String, labelProbs: [String : Double]) {
        self.provider = try! MLDictionaryFeatureProvider(dictionary: ["label" : MLFeatureValue(string: label), "labelProbs" : MLFeatureValue(dictionary: labelProbs as [AnyHashable : NSNumber])])
    }
    
    init(features: MLFeatureProvider) {
        self.provider = features
    }
}


/// Model Update Input Type
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
class UpdatableDrawingClassifierTrainingInput : MLFeatureProvider {
    
    /// Example sketch as grayscale (kCVPixelFormatType_OneComponent8) image buffer, 28 pixels wide by 28 pixels high
    var drawing: CVPixelBuffer
    
    /// Associated true label of example sketch as string value
    var label: String
    
    var featureNames: Set<String> {
        get {
            return ["drawing", "label"]
        }
    }
    
    func featureValue(for featureName: String) -> MLFeatureValue? {
        if (featureName == "drawing") {
            return MLFeatureValue(pixelBuffer: drawing)
        }
        if (featureName == "label") {
            return MLFeatureValue(string: label)
        }
        return nil
    }
    
    init(drawing: CVPixelBuffer, label: String) {
        self.drawing = drawing
        self.label = label
    }
}

/// Class for model loading and prediction
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
class UpdatableDrawingClassifier {
    var model: MLModel
    
    /// URL of model assuming it was installed in the same bundle as this class
    class var urlOfModelInThisBundle : URL {
        let bundle = Bundle(for: UpdatableDrawingClassifier.self)
        return bundle.url(forResource: "UpdatableDrawingClassifier", withExtension:"mlmodelc")!
    }
    
    /**
     Construct a model with explicit path to mlmodelc file
     - parameters:
     - url: the file url of the model
     - throws: an NSError object that describes the problem
     */
    init(contentsOf url: URL) throws {
        self.model = try MLModel(contentsOf: url)
    }
    
    /// Construct a model that automatically loads the model from the app's bundle
    convenience init() {
        try! self.init(contentsOf: type(of:self).urlOfModelInThisBundle)
    }
    
    /**
     Construct a model with configuration
     - parameters:
     - configuration: the desired model configuration
     - throws: an NSError object that describes the problem
     */
    convenience init(configuration: MLModelConfiguration) throws {
        try self.init(contentsOf: type(of:self).urlOfModelInThisBundle, configuration: configuration)
    }
    
    /**
     Construct a model with explicit path to mlmodelc file and configuration
     - parameters:
     - url: the file url of the model
     - configuration: the desired model configuration
     - throws: an NSError object that describes the problem
     */
    init(contentsOf url: URL, configuration: MLModelConfiguration) throws {
        self.model = try MLModel(contentsOf: url, configuration: configuration)
    }
    
    /**
     Make a prediction using the structured interface
     - parameters:
     - input: the input to the prediction as UpdatableDrawingClassifierInput
     - throws: an NSError object that describes the problem
     - returns: the result of the prediction as UpdatableDrawingClassifierOutput
     */
    func prediction(input: UpdatableDrawingClassifierInput) throws -> UpdatableDrawingClassifierOutput {
        return try self.prediction(input: input, options: MLPredictionOptions())
    }
    
    /**
     Make a prediction using the structured interface
     - parameters:
     - input: the input to the prediction as UpdatableDrawingClassifierInput
     - options: prediction options
     - throws: an NSError object that describes the problem
     - returns: the result of the prediction as UpdatableDrawingClassifierOutput
     */
    func prediction(input: UpdatableDrawingClassifierInput, options: MLPredictionOptions) throws -> UpdatableDrawingClassifierOutput {
        let outFeatures = try model.prediction(from: input, options:options)
        return UpdatableDrawingClassifierOutput(features: outFeatures)
    }
    
    /**
     Make a prediction using the convenience interface
     - parameters:
     - drawing: Input sketch image with black background and white strokes as grayscale (kCVPixelFormatType_OneComponent8) image buffer, 28 pixels wide by 28 pixels high
     - throws: an NSError object that describes the problem
     - returns: the result of the prediction as UpdatableDrawingClassifierOutput
     */
    func prediction(drawing: CVPixelBuffer) throws -> UpdatableDrawingClassifierOutput {
        let input_ = UpdatableDrawingClassifierInput(drawing: drawing)
        return try self.prediction(input: input_)
    }
    
    /**
     Make a batch prediction using the structured interface
     - parameters:
     - inputs: the inputs to the prediction as [UpdatableDrawingClassifierInput]
     - options: prediction options
     - throws: an NSError object that describes the problem
     - returns: the result of the prediction as [UpdatableDrawingClassifierOutput]
     */
    func predictions(inputs: [UpdatableDrawingClassifierInput], options: MLPredictionOptions = MLPredictionOptions()) throws -> [UpdatableDrawingClassifierOutput] {
        let batchIn = MLArrayBatchProvider(array: inputs)
        let batchOut = try model.predictions(from: batchIn, options: options)
        var results : [UpdatableDrawingClassifierOutput] = []
        results.reserveCapacity(inputs.count)
        for i in 0..<batchOut.count {
            let outProvider = batchOut.features(at: i)
            let result =  UpdatableDrawingClassifierOutput(features: outProvider)
            results.append(result)
        }
        return results
    }
}
