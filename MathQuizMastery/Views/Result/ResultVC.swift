//
//  ResultVC.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 14.01.2025.
//

import UIKit

class ResultVC: UIViewController {
    @IBOutlet weak var scoreLabel: NeonLabel!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var restartButton: UIButton!
    @IBOutlet weak var categoryButton: UIButton!
    
    var receivedScore: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scoreLabel.text = "\(receivedScore)"
        
        categoryButton.clipsToBounds = true
        navigationItem.hidesBackButton = true
    }
    
    @IBAction func goToHome(_ sender: UIButton, forEvent event: UIEvent) {
       // navigateToHome()
    }
    
    @IBAction func goToCategory(_ sender: Any, forEvent event: UIEvent) {
       // navigateToCategory()
    }
    
    @IBAction func goToGame(_ sender: Any) {
        
    }
}

extension ResultVC {
    
    func navigateToHome() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeVC") as? HomeVC {
            navigationController?.setViewControllers([homeVC], animated: true)
        }
    }

    func navigateToCategory() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let categoryVC = storyboard.instantiateViewController(withIdentifier: "CategoryVC") as? CategoryVC {
            navigationController?.setViewControllers([categoryVC], animated: true)
        }
    }
}

