//
//  ResultVC.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 14.01.2025.
//

import UIKit

class ResultVC: UIViewController {
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var kategoriButtonLabel: UIButton!
    var receivedScore: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.text = receivedScore
        
        kategoriButtonLabel.layer.cornerRadius = 20
        kategoriButtonLabel.clipsToBounds = true
        navigationItem.hidesBackButton = true
        
    }
}
