//
// Copyright (c) Purav Manot
//


import Foundation

struct PaperHistory {
    var openCount: Int
    var solvedData: [PaperSolvedData] = []
}

struct PaperSolvedData {
    init(_ solvedPaper: SolvedPaper){
        self.paperCode = solvedPaper.paperCode
        self.correct = solvedPaper.correctAnswers.count
        self.incorrect = solvedPaper.incorrectAnswers.count
        self.unattempted = solvedPaper.unsolvedAnswers.count
        self.timeTaken = 0
        self.solvedOn = solvedPaper.solvedOn
    }
    init(paperCode: String, correct: Int, incorrect: Int, unattempted: Int, timeTaken: TimeInterval){
        self.paperCode = paperCode
        self.correct = correct
        self.incorrect = incorrect
        self.unattempted = unattempted
        self.timeTaken = timeTaken
    }
    
    var paperCode: String
    
    var solvedOn: Date = Date()
    var correct: Int
    var incorrect: Int
    var unattempted: Int
    var timeTaken: TimeInterval
    
}

struct SolvedPaper: Codable, Hashable, Identifiable {
    var id = UUID()
    var paperCode: String
    var solvedOn: Date = Date()
    var answers: [QuestionIndex : MultipleChoiceAnswer] = [:]
    var correctAnswers: [QuestionIndex] = []
    var incorrectAnswers: [QuestionIndex] = []
    var unsolvedAnswers: [QuestionIndex] = []

    var allAnswers: [QuestionIndex] {
        correctAnswers + incorrectAnswers + unsolvedAnswers
    }
    
    init(bundle: CambridgePaperBundle, answers: [QuestionIndex : MultipleChoiceAnswer]){
        paperCode = bundle.metadata.code
        self.answers = answers
        if bundle.markScheme != nil {
            self.check(markschemeAnswers: bundle.markScheme!.metadata.multipleChoiceAnswers)
        }
    }
    
    
    init(paper: CambridgePaper, answers: [QuestionIndex : MultipleChoiceAnswer]){
        self.paperCode = paper.metadata.code
        self.answers = answers
    }
    
    
    // testing and debugging
    init(answers: [QuestionIndex : MultipleChoiceAnswer], correctAnswers: [QuestionIndex : MultipleChoiceAnswer]){
        self.paperCode = "9702_s18_qp_11"
        self.answers = answers
        self.check(markschemeAnswers: correctAnswers)
    }
    
    mutating func check(markschemeAnswers: [QuestionIndex : MultipleChoiceAnswer]){
        
        for i in [Int](1...40).map({ QuestionIndex($0) }){
            switch answers[i]!.value {
                case .none:
                    unsolvedAnswers.append(i)
                case markschemeAnswers[i]!.value:
                    correctAnswers.append(i)
                default:
                    incorrectAnswers.append(i)
            }
        }
    }
    
}

extension SolvedPaper {
    static func makeNewExample() -> SolvedPaper {
        SolvedPaper(answers: [:], correctAnswers: [:])
    }
}

extension Array where Element == Answer {
    func getAnswersByIndex() -> Answers {
        Dictionary(uniqueKeysWithValues: self.map { ($0.index, $0.value) })
    }
}
