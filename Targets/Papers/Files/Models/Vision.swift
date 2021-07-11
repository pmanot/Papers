//
// Copyright (c) Purav Manot
//

import Foundation
import Vision

func recogniseText(from image: CGImage) -> String {
    var recognizedText = ""
    let recognizeTextRequest = VNRecognizeTextRequest { (request, error) in
        guard error == nil else { return }
        
        guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
        
        let maximumRecognitionCandidates = 1
        for observation in observations {
            guard let candidate = observation.topCandidates(maximumRecognitionCandidates).first else { continue }
            
            recognizedText = "\(candidate.string)"
            
        }
    }
    recognizeTextRequest.recognitionLevel = .accurate
    
    let requestHandler = VNImageRequestHandler(cgImage: image, options: [:])
    try? requestHandler.perform([recognizeTextRequest])
    
    return recognizedText
}