//
// Copyright (c) Purav Manot
//


import Foundation



class PapersSolvedData {
    
    @Published var answersByPaperCode: [String : UserAnswers] = [:]
    
    init(){
        
    }
    
    
    func check(metadata: CambridgePaperMetadata){
        let indexToAnswerMap = Dictionary(metadata.answers.map({ ($0.index, $0) }), uniquingKeysWith: { x, y in x })
        
        if (answersByPaperCode[metadata.paperCode] != nil) {
            let userAnswers = answersByPaperCode[metadata.paperCode]!
            for index in userAnswers.inputtedAnswers.map { $0.inputtedAnswer.index } {
                //userAnswers.inputtedAnswers.first { $0.inputtedAnswer }
            }
        }
    }
}



struct UserAnswers: Codable, Hashable {
    var solveDate: Date = Date()
    var inputtedAnswers: [UserAnswer]
    var checked: Bool = false
}

struct UserAnswer: Codable, Hashable {
    var inputtedAnswer: Answer
    var correctAnswer: Answer?
    var check: QuestionCheck = .unsolved
    
}
