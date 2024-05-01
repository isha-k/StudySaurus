//
//  Question.swift
//  StudySaurus
//
//  Created by Isha Kaur on 29/4/2024.
//

import UIKit
import FirebaseFirestoreSwift

enum CodingKeys: String, CodingKey {
    case id
    case question
    case correctAnswer
    case answers
}

class Question: NSObject, Codable {
    @DocumentID var id: String?
    var question: String?
    var correctAnswer: String?
    var answers: [String]?
}


