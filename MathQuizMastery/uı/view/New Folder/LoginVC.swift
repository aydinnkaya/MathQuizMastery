//
//  LoginVC.swift
//  MathQuizMastery
//
//  Created by Aydın KAYA on 18.01.2025.
//

import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var headerView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        headerView.transform = CGAffineTransform(rotationAngle: -70 * .pi / 180)
        
    }
    

    


}
