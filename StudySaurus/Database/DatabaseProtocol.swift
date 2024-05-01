//
//  DatabaseProtocol.swift
//  FIT3178-W04-Lab
//
//  Created by Jason Haasz on 4/1/2023.
//

import Foundation
import FirebaseAuth

enum DatabaseChange{
    case add
    case remove
    case update
}

enum ListenerType {
    case quiz
    case quizzes
    case questions
    case all
}

protocol DatabaseListener: AnyObject {
    var listenerType: ListenerType {get set}
    func onQuizChange(change: DatabaseChange, quizQuestions: [Question])
    func onQuizzesChange(change: DatabaseChange, quizzes: [Quiz])
    func onQuestionsChange(change: DatabaseChange, questions: [Question])
}

protocol DatabaseProtocol: AnyObject {
    func cleanup()
    
    func addListener(listener: DatabaseListener)
    func removeListener(listener: DatabaseListener)
    
    func addQuestion(question: String, correctAnswer:String, answers: [String]) -> Question
    func deleteQuestion(question: Question)
    
    var defaultQuiz: Quiz {get}
    func addQuiz(quizName: String) -> Quiz
    func deleteQuiz(quiz: Quiz)
    func addQuestionToQuiz(question: Question, quiz: Quiz) -> Bool
    func removeQuestionFromQuiz(question: Question, quiz: Quiz)
}


