//
// Copyright (c) Purav Manot
//

import Foundation
import Swallow
import Vision

public protocol VNRequestConfiguration {
    associatedtype Observation: VNObservation

    func toVNRequest(completion: @escaping (Result<Void, Error>) -> Void) -> VNRequest
}

public struct VNRecognizeTextRequestConfiguration: VNRequestConfiguration {
    public typealias Observation = VNRecognizedTextObservation

    public let recognitionLanguages: [String]?
    public let customWords: [String]?
    public let recognitionLevel: VNRequestTextRecognitionLevel?
    public let usesLanguageCorrection: Bool?
    public let automaticallyDetectsLanguage: Bool?
    public let minimumTextHeight: Float?

    public init(
        recognitionLanguages: [String]? = nil,
        customWords: [String]? = nil,
        recognitionLevel: VNRequestTextRecognitionLevel? = nil,
        usesLanguageCorrection: Bool? = nil,
        automaticallyDetectsLanguage: Bool? = nil,
        minimumTextHeight: Float? = nil
    ) {
        self.recognitionLanguages = recognitionLanguages
        self.customWords = customWords
        self.recognitionLevel = recognitionLevel
        self.usesLanguageCorrection = usesLanguageCorrection
        self.automaticallyDetectsLanguage = automaticallyDetectsLanguage
        self.minimumTextHeight = minimumTextHeight
    }

    public func toVNRequest(
        completion: @escaping (Result<Void, Error>) -> Void
    ) -> VNRequest {
        let request = VNRecognizeTextRequest { request, error in
            if let error = error {
                completion(.failure(error))
            } else if request.results != nil {
                completion(.success(()))
            } else {
                fatalError()
            }
        }

        if let recognitionLanguages = recognitionLanguages {
            request.recognitionLanguages = recognitionLanguages
        }

        if let customWords = customWords {
            request.customWords = customWords
        }

        if let recognitionLevel = recognitionLevel {
            request.recognitionLevel = recognitionLevel
        }

        if let usesLanguageCorrection = usesLanguageCorrection {
            request.usesLanguageCorrection = usesLanguageCorrection
        }

        if let automaticallyDetectsLanguage = automaticallyDetectsLanguage {
            if #available(iOS 16.0, *) {
                request.automaticallyDetectsLanguage = automaticallyDetectsLanguage
            }
        }

        if let minimumTextHeight = minimumTextHeight {
            request.minimumTextHeight = minimumTextHeight
        }

        return request
    }
}

extension VNImageRequestHandler {
    public func performRequest<Configuration: VNRequestConfiguration>(
        withConfiguration configuration: Configuration,
        priority: TaskPriority? = nil
    ) async throws -> [Configuration.Observation] {
        try await Task.detached(priority: priority) {
            let request = configuration.toVNRequest(completion: { _ in })

            try self.perform([request])

            return try cast(request.results.unwrap(), to: [Configuration.Observation].self)
        }
        .value
    }
}


extension Array where Element == VNRecognizedTextObservation {
    public func firstTopCandidate() -> VNRecognizedText? {
        lazy.compactMap({ $0.topCandidates(1).first }).first
    }
}
