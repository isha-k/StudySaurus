//
//  QuizHomeTableViewController.swift
//  StudySaurus
//
//  Created by Isha Kaur on 29/4/2024.
//

import UIKit

class QuizHomeTableViewController: UITableViewController, UISearchResultsUpdating, DatabaseListener {
    func onQuizzesChange(change: DatabaseChange, quizzes: [Quiz]) {
        self.quizzes = quizzes
        updateSearchResults(for: navigationItem.searchController!)
        tableView.reloadData()
    }
    
    @IBAction func newQuiz(_ sender: Any) {
        //
    }
    
    
    func onQuizChange(change: DatabaseChange, quizQuestions: [Question]) {
        //
    }
    
    func onQuestionsChange(change: DatabaseChange, questions: [Question]) {
        //
    }
    
    
    let CELL_QUIZ = "quizCell"
    var quizzes: [Quiz] = []
    var filteredQuizzes: [Quiz] = []
    
    var listenerType: ListenerType = .quizzes
    weak var databaseController: DatabaseProtocol?
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search All Quizzes"
        navigationItem.searchController = searchController
                
        // This view controller decides how the search controller is presented
        definesPresentationContext = true

        filteredQuizzes = quizzes
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filteredQuizzes.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_QUIZ, for: indexPath)
        var content = cell.defaultContentConfiguration()
        let quiz = quizzes[indexPath.row]
        
        content.text = quiz.title
        cell.contentConfiguration = content
       
        return cell
    }
    

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else {
            return
        }

        if searchText.count > 0 {
            filteredQuizzes = quizzes.filter({ (quiz: Quiz) -> Bool in
                return (quiz.title?.lowercased().contains(searchText) ?? false)
            })
        } else {
            filteredQuizzes = quizzes
        }

        tableView.reloadData()
    }
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let quiz = filteredQuizzes[indexPath.row]
            databaseController?.deleteQuiz(quiz: quiz)
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
