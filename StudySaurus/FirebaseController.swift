//
//  FirebaseController.swift
//  StudySaurus
//
//  Created by Isha Kaur on 29/4/2024.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift
import FirebaseAuth

class FirebaseController: NSObject, DatabaseProtocol {
    let DEFAULT_QUIZ_NAME = "Default Quiz"
    var listeners = MulticastDelegate<DatabaseListener>()
    var questionList: [Question]
    var quizList: [Quiz]
    var defaultQuiz: Quiz

    var authController: Auth
    var database: Firestore
    var questionsRef: CollectionReference?
    var quizzesRef: CollectionReference?
    var currentUser: FirebaseAuth.User?

    override init() {
        FirebaseApp.configure()
        authController = Auth.auth()
        database = Firestore.firestore()
        questionList = [Question]()
        defaultQuiz = Quiz()
        quizList = [Quiz]()
        
        super.init()
        
        
        //Anonymous auth code
        Task {
            do {
                let authDataResult = try await authController.signInAnonymously()
                currentUser = authDataResult.user
            }
            catch {
                fatalError("Firebase Authentication Failed with Error\(String(describing: error))")
            }
        }
    }
        
        
    func cleanup() {
        //
    }


    func addListener(listener: DatabaseListener) {
        listeners.addDelegate(listener)
          
        // Check the type of the listener and notify accordingly
        if listener.listenerType == .quiz || listener.listenerType == .all {
            listener.onQuizChange(change: .update, quizQuestions: defaultQuiz.questions ?? [])
        }
        
        // Check the type of the listener and notify accordingly
//        if listener.listenerType == .quizzes || listener.listenerType == .all {
//            listener.onQuizzesChange(change: .update, quizzes: defaultQuizzes)
//        }

        if listener.listenerType == .questions || listener.listenerType == .all {
            listener.onQuestionsChange(change: .update, questions: questionList)
        }
    }
    
    func removeListener(listener: DatabaseListener) {
        listeners.removeDelegate(listener)
    }
    
    func addQuestion(question: String, correctAnswer: String, answers: [String]) -> Question {
        let newQuestion = Question()
        newQuestion.question = question
        newQuestion.correctAnswer = correctAnswer
        
        do {
            if let questionRef = questionsRef?.addDocument(data: ["question" : question]) {
                newQuestion.id = questionRef.documentID
            }
        } catch {
            print("Failed to serialize question")
        }
        
        return newQuestion
    }
    
    func addQuiz(quizName: String) -> Quiz {
        let quiz = Quiz()
        quiz.title = quizName
        if let quizRef = quizzesRef?.addDocument(data: ["title" : quizName]) {
            quiz.id = quizRef.documentID
        }
        return quiz
    }
    
    func deleteQuestion(question: Question) {
        if let questionID = question.id {
            questionsRef?.document(questionID).delete()
        }
    }
    
    
    func deleteQuiz(quiz: Quiz) {
        if let quizID = quiz.id {
            quizzesRef?.document(quizID).delete()
        }
    }
    
    func addQuestionToQuiz(question: Question, quiz: Quiz) -> Bool {
        guard let questionID = question.id, let quizID = quiz.id else {
            return false
        }
        
        if let newQuestionRef = questionsRef?.document(questionID) {
            quizzesRef?.document(quizID).updateData( ["questions" : FieldValue.arrayUnion([newQuestionRef])]
            )
        }
        
        return true
    }
    
    func removeQuestionFromQuiz(question: Question, quiz: Quiz) {
        if quiz.questions.contains(question), let quizID = quiz.id, let questionID = question.id {
            if let removedQuestionRef = questionsRef?.document(questionID) {
                quizzesRef?.document(quizID).updateData(["questions": FieldValue.arrayRemove([removedQuestionRef])]
                )
            }
        }
    }
    
    func getQuestionByID(_ id: String) -> Question? {
        for question in questionList {
            if question.id == id {
                return question
            }
        }
        
        return nil
    }
    
    func setupQuestionListener() {
        questionsRef = database.collection("questions")
        
        questionsRef?.addSnapshotListener() { (querySnapshot, error) in
            guard let querySnapshot = querySnapshot else {
                print("Failed to fetch documents with error: \(String(describing: error))")
                return
            }
            
            self.parseQuestionsSnapshot(snapshot: querySnapshot)
            
            if self.quizzesRef == nil {
                self.setupQuizListener()
            }
        }
    }
    
    func setupQuizListener() {
        quizzesRef = database.collection("quizzes")
        quizzesRef?.whereField("title", isEqualTo: DEFAULT_QUIZ_NAME).addSnapshotListener { (querySnapshot, error) in
            guard let querySnapshot = querySnapshot, let quizSnapshot =
                querySnapshot.documents.first else {
                print("Error fetching teams: \(error!)")
                return
            }
            self.parseQuizSnapshot(snapshot: quizSnapshot)
        }
    }

    
    func parseQuestionsSnapshot(snapshot: QuerySnapshot) {
        snapshot.documentChanges.forEach { (change) in
            var question: Question
            do {
                question = try change.document.data(as: Question.self)
            } catch {
                fatalError("Unable to decode hero: \(error.localizedDescription)")
            }
            
            if change.type == .added {
                questionList.insert(question, at: Int(change.newIndex))
            } else if change.type == .modified {
                questionList.remove(at: Int(change.oldIndex))
                questionList.insert(question, at: Int(change.newIndex))
            } else if change.type == .removed {
                questionList.remove(at: Int(change.oldIndex))
            }
            listeners.invoke { (listener) in
                if listener.listenerType == ListenerType.questions || listener.listenerType == ListenerType.all {
                    listener.onQuestionsChange(change: .update, questions: questionList)
                }
            }

        }
    }
    
    func parseQuizSnapshot(snapshot: QueryDocumentSnapshot) {
        defaultQuiz = Quiz()
        defaultQuiz.title = snapshot.data()["title"] as? String
        defaultQuiz.id = snapshot.documentID
        
        if let questionReferences = snapshot.data()["questions"] as? [DocumentReference] {
            for reference in questionReferences {
                if let question = getQuestionByID(reference.documentID) {
                    defaultQuiz.questions.append(question)
                }
            }
        }
        listeners.invoke { (listener) in
            if listener.listenerType == ListenerType.quiz || listener.listenerType == ListenerType.all {
                listener.onQuizChange(change: .update, quizQuestions: defaultQuiz.questions)
            }
        }
    }
    
//    func parseQuizzesSnapshot(snapshot: QuerySnapshot) {
//        snapshot.documentChanges.forEach { (change) in
//            let documentData = change.document.data()
//            let quizID = change.document.documentID
//                    
//            guard let nameText = documentData["title"] as? String,
//                  let questionsList = documentData["questions"] as? [String] else {
//                return
//            }
//            
//            let quizzes = Quiz(id: quizID, title: nameText, questions: questionsList)
//                    
//            if change.type == .added {
//                questionList.insert(question, at: Int(change.newIndex))
//            } else if change.type == .modified {
//                questionList.remove(at: Int(change.oldIndex))
//                questionList.insert(question, at: Int(change.newIndex))
//            } else if change.type == .removed {
//                questionList.remove(at: Int(change.oldIndex))
//            }
//            listeners.invoke { (listener) in
//                if listener.listenerType == ListenerType.quizzes || listener.listenerType == ListenerType.all {
//                    listener.onQuizzesChange(change: .update, questions: questionList)
//                }
//            }
//        }
//    }
    
    
}


