//
//  DatabaseProtocol.swift
//  FIT3178-W04-Lab
//
//  Created by Jason Haasz on 4/1/2023.
//

import UIKit

class CurrentQuizTableViewController: UITableViewController, DatabaseListener {
    func onQuizzesChange(change: DatabaseChange, quizzes: [Quiz]) {
        //
    }
    
    var listenerType: ListenerType = .quiz
    weak var databaseController: DatabaseProtocol?

    let SECTION_QUESTION = 0
    let SECTION_INFO = 1

    let CELL_QUESTION = "questionCell"
    let CELL_INFO = "questionNumberCell"

    var currentQuiz: [Question] = []
    var selectedQuiz: Quiz = Quiz()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case SECTION_QUESTION:
                return currentQuiz.count
            case SECTION_INFO:
                return 1
            default:
                return 0
        }
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == SECTION_QUESTION {
            // Configure and return a hero cell
            let questionCell = tableView.dequeueReusableCell(withIdentifier: CELL_QUESTION, for: indexPath)
            
            var content = questionCell.defaultContentConfiguration()
            let question = currentQuiz[indexPath.row]
            content.text = question.question
            questionCell.contentConfiguration = content
            
            return questionCell
        }
        else {
            // Configure and return an info cell instead
            let infoCell = tableView.dequeueReusableCell(withIdentifier: CELL_INFO, for: indexPath)
                    
            let questionCount = currentQuiz.count
            var content = infoCell.defaultContentConfiguration()
            if questionCount == 0 {
                content.text = "No questions in Quiz. Tap + to add some."
            } else {
                content.text = "\(questionCount) questions in the quiz"
            }
            infoCell.contentConfiguration = content

            return infoCell
        }
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == SECTION_QUESTION {
            return true
        }

        return false
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.databaseController?.removeQuestionFromQuiz(question: currentQuiz[indexPath.row], quiz: databaseController!.defaultQuiz)
        }
    }
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
    }

    // MARK: - Add Superhero Delegate

    func addQuestion(_ newQuestion: Question) -> Bool {
            return databaseController?.addQuestionToQuiz(question: newQuestion, quiz: databaseController!.defaultQuiz) ?? false
    }
    
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if section == SECTION_QUESTION {
//            return "Default Quizzes:"
//        }
//        return nil
//    }
    
    
    func onQuizChange(change: DatabaseChange, quizQuestions: [Question]) {
        currentQuiz = quizQuestions
        tableView.reloadData()
    }
    
    func onQuestionsChange(change: DatabaseChange, questions: [Question]) {
        //
    }
}
