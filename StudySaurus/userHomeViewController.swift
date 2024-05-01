//
//  userHomeViewController.swift
//  StudySaurus
//
//  Created by Isha Kaur on 29/4/2024.
//

import UIKit
import Lottie
import SwiftUI
import Firebase

class userHomeViewController: UIViewController {
    
    @IBAction func logoutButton(_ sender: UIBarButtonItem) {
        do {
          try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
     
        
//
//        animationView.contentMode = .scaleAspectFill
//        animationView.loopMode = .loop
//        animationView.animationSpeed = 1.0
//        animationView.play()
//        
//        cactusPlant.contentMode = .scaleToFill
//        cactusPlant.loopMode = .loop
//        cactusPlant.animationSpeed = 0.7
//        cactusPlant.play()
        
        
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
