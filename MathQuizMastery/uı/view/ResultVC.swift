//
//  ResultVC.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 14.01.2025.
//

import UIKit

class ResultVC: UIViewController {
    @IBOutlet weak var label: UILabel!
    
    var receivedScore: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
 
        label.text = receivedScore
        
    }
}
