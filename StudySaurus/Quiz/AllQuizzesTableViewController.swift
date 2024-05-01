//
//  AllQuizzesTableViewController.swift
//  StudySaurus
//
//  Created by Isha Kaur on 30/4/2024.
//

import UIKit
import FirebaseCore
import FirebaseFirestore

class AllQuizzesTableViewController: UITableViewController {
    let CELL_QUIZ = "quizCell"
    var quizzes: [Quiz] = []
    var quiz = Quiz()
    
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadQuizzes()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func loadQuizzes() {
        db.collection("quizzes").getDocuments { (querySnapshot, error) in
            if let e = error {
                print("Issue receiving data from Firestore. \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        let id = doc.documentID
                        let quizTitle = data["title"] as? String ?? ""
                        let quizQuestions = data["questions"] as? Array ?? [Question]()
                        
                        let quiz = Quiz(id: id, title: quizTitle, questions: quizQuestions)
                        
                        self.quizzes.append(quiz)
                    }
                    
                    self.tableView.reloadData()
                }
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return quizzes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_QUIZ, for: indexPath)

        // Configure the cell...
        let quiz = quizzes[indexPath.row]
        cell.textLabel?.text = quiz.title

        return cell
    }
    

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        }    
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "currentQuiz", sender: quizzes[indexPath.row])
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "currentQuiz" {
            if let quizQuestionsVC = segue.destination as? CurrentQuizTableViewController,
               let selectedQuiz = sender as? Quiz {
                quizQuestionsVC.selectedQuiz = selectedQuiz
            }
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
