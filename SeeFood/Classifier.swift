//
//  GarbageClassifier.swift
//  SeeFood
//
//  Created by Justin Cheung on 12/24/20.
//

import CoreML
import ImageIO
import SwiftUI
import Vision

class Classifier: ObservableObject {

    private(set) var image: UIImage?

    private(set) var errorMessage: String?

    private(set) var classifications: [VNClassificationObservation]?

    @Published
    private(set) var isProcessing: Bool

    private lazy var classificationRequest: VNCoreMLRequest = createClassificationRequest()

    var label: String? {
        guard let classifications = self.classifications else {
            return nil
        }

        return classifications[0].identifier
    }

    init() {
        self.image = nil
        self.errorMessage = nil
        self.classifications = nil
        self.isProcessing = false
    }

    func classify(image: UIImage) {

        //
        // Reset fields
        //

        self.image = image
        self.errorMessage = nil
        self.classifications = nil
        self.isProcessing = true

        //
        // Get the image orientation
        //

        let orientation = CGImagePropertyOrientation(image.imageOrientation)

        //
        // Create CIImage from image
        //

        guard let ciImage = CIImage(image: image) else {
            fatalError("Unable to create \(CIImage.self) from \(image).")
        }

        //
        // Start asynchronous classification
        // request
        //

        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation)

            do {
                try handler.perform([self.classificationRequest])
            } catch {
                print("Failed to perform classification: \(error.localizedDescription)")
            }
        }
    }

    private func createClassificationRequest() -> VNCoreMLRequest {

        //
        // Create instance of Vision Core ML
        // model
        //

        let config = MLModelConfiguration()
        var model: VNCoreMLModel

        do {
            model = try VNCoreMLModel(for: HotDogNet(configuration: config).model)
        } catch {
            fatalError("Failed to load the Vision Core ML model: \(error.localizedDescription)")
        }

        //
        // Create instance of image analysis
        // request based on model
        //

        let request = VNCoreMLRequest(model: model) { request, error in
            self.processClassifications(for: request, error: error)
        }

        //
        // Use Vision to crop input image to
        // what the model expects
        //

        request.imageCropAndScaleOption = .centerCrop
        return request
    }

    private func processClassifications(for request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            guard let results = request.results else {
                self.errorMessage = "Failed to classify image: \(error?.localizedDescription ?? "")"
                return
            }

            self.classifications = results as? [VNClassificationObservation]
            self.isProcessing = false
        }
    }
}
