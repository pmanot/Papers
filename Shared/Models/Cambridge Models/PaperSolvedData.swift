//
// Copyright (c) Purav Manot
//


import Foundation


struct SolvedPaper: Codable, Hashable {
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
        
        for i in [Int](1...40).map({ QuestionIndex($0) }) {
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



extension Array where Element == Answer {
    func getAnswersByIndex() -> Answers {
        Dictionary(uniqueKeysWithValues: self.map { ($0.index, $0.value) })
    }
}
