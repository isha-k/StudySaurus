//
//  AddQuestionViewController.swift
//  StudySaurus
//
//  Created by Isha Kaur on 30/4/2024.
//

import UIKit
import Firebase

class AddQuestionViewController: UIViewController {
    
    @IBOutlet weak var questionTextField: UITextField!
    @IBOutlet weak var answerTextField: UITextField!
    @IBOutlet weak var choiceOneText: UITextField!
    @IBOutlet weak var choiceTwoText: UITextField!
    @IBOutlet weak var choiceThreeText: UITextField!
    var options: [String] = []
    let db = Firestore.firestore()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func addQuestion(_ sender: Any) {
        let question = questionTextField.text
        let answer = answerTextField.text
        
        if let choice1 = choiceOneText.text, let choice2 = choiceTwoText.text, let choice3 = choiceThreeText.text {
            options.append(choice1)
            options.append(choice2)
            options.append(choice3)
        } else {
            displayMessage(title: "Add Options", message: "Please fill in all multichoice options for the question")
        }
        
       
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
