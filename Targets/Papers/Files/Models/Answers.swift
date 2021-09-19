//
// Copyright (c) Purav Manot
//

import Foundation

public final class Answers: ObservableObject {
    var data: CodableAnswers
    init(_ answers: [Answer] = []){
        self.data = CodableAnswers(answers)
    }
    
}
