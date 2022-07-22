//
// Copyright (c) Purav Manot
//

import Foundation
import Swallow
import Vision

func recognizeText(from image: CGImage) async throws -> String? {
    let requestHandler = VNImageRequestHandler(cgImage: image, options: [:])

    let observations = try await requestHandler.performRequest(
        withConfiguration: VNRecognizeTextRequestConfiguration(
            customWords: Array(1..<10).map({ "\($0)" }),
            recognitionLevel: .accurate,
            usesLanguageCorrection: false
        )
    )

    return observations.firstTopCandidate()?.string
}

func recognizeAllText(
    from image: CGImage,
    _ recognitionLevel: VNRequestTextRecognitionLevel = .accurate,
    lookFor customWords: [String]
) async throws -> String {
    let requestHandler = VNImageRequestHandler(cgImage: image, options: [:])

    let observations = try await requestHandler.performRequest(
        withConfiguration: VNRecognizeTextRequestConfiguration(
            customWords: customWords,
            recognitionLevel: recognitionLevel,
            usesLanguageCorrection: false
        )
    )

    return observations
        .compactMap {
            $0.topCandidates(1).first
        }
        .reduce(into: "") { result, candidate in
            result += "\(candidate.string) "
        }
}
