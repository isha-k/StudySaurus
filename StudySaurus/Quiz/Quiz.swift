//
//  Quiz.swift
//  StudySaurus
//
//  Created by Isha Kaur on 29/4/2024.
//

import UIKit

class Quiz: NSObject {
    var id: String?
    var title: String?
    var questions: [Question]
    
    init(id: String? = nil, title: String? = nil, questions: [Question] = []) {
        self.id = id
        self.title = title
        self.questions = questions
    }

}
