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
    var answers: [Answer] = []
    var correctAnswers: [Answer] = []
    var incorrectAnswers: [Answer] = []
    var unsolvedAnswers: [Answer] = []

    var allAnswers: [Answer] {
        correctAnswers + incorrectAnswers + unsolvedAnswers
    }
    
    init(bundle: CambridgePaperBundle, answers: [Answer]){
        paperCode = bundle.metadata.paperCode
        self.answers = answers
        if bundle.markScheme != nil {
            self.check(markschemeAnswers: bundle.markScheme!.metadata.answers)
        }
    }
    
    
    init(paper: CambridgeQuestionPaper, answers: [Answer]){
        self.paperCode = paper.metadata.paperCode
        self.answers = answers
    }
    
    
    // testing and debugging
    init(answers: [Answer], correctAnswers: [Answer]){
        self.paperCode = "9702_s18_qp_11"
        self.answers = answers
        self.check(markschemeAnswers: correctAnswers)
    }
    
    mutating func check(markschemeAnswers: [Answer]){
        let correctAnswersByIndex = markschemeAnswers.getAnswersByIndex()
        let answersByIndex = answers.getAnswersByIndex()
        
        for i in [Int](1...40).map({ OldQuestionIndex($0) }){
            if answersByIndex[i] == .multipleChoice(choice: .none){
                unsolvedAnswers.append(Answer(index: i, value: answersByIndex[i]!))
            } else {
                if answersByIndex[i] == correctAnswersByIndex[i] {
                    correctAnswers.append(Answer(index: i, value: answersByIndex[i]!))
                } else {
                    incorrectAnswers.append(Answer(index: i, value: answersByIndex[i]!))
                }
            }
        }
    }
    
}

extension SolvedPaper {
    static func makeNewExample() -> SolvedPaper {
        SolvedPaper(answers: [Answer].exampleAnswers, correctAnswers: [Answer].exampleCorrectAnswers)
    }
}



extension Array where Element == Answer {
    func getAnswersByIndex() -> Answers {
        Dictionary(uniqueKeysWithValues: self.map { ($0.index, $0.value) })
    }
}
