//
//  CategoryVC.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 16.01.2025.
//

import UIKit

class CategoryVC: UIViewController {
    
    @IBOutlet weak var ButtonToplamaLabel: UIButton!
    @IBOutlet weak var buttonÇıkarmaLabel: UIButton!
    @IBOutlet weak var buttonÇarpmaLabel: UIButton!
    @IBOutlet weak var buttonBölmeLabel: UIButton!
    @IBOutlet weak var buttonKarisikLabel: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureButton(ButtonToplamaLabel)
        configureButton(buttonÇıkarmaLabel)
        configureButton(buttonÇarpmaLabel)
        configureButton(buttonBölmeLabel)
        configureButton(buttonKarisikLabel)
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        
        var selectedExpression: MathExpression.ExpressionType? // ifade

        switch sender {
        case ButtonToplamaLabel:
            selectedExpression = .addition
        case buttonÇıkarmaLabel:
            selectedExpression = .subtraction
        case buttonÇarpmaLabel:
            selectedExpression = .multiplication
        case buttonBölmeLabel:
            selectedExpression = .division
        case buttonKarisikLabel:
            selectedExpression = .mixed
        default:
            break
        }

        if let expression = selectedExpression {
            performSegue(withIdentifier: "goToGame", sender: expression)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToGame",
           let destinationVC = segue.destination as? GameVC,
           let selectedExpression = sender as? MathExpression.ExpressionType {
            destinationVC.selectedExpressionType = selectedExpression
        }
    }
  
}

extension CategoryVC {
    
    func configureButton(_ button : UIButton){
        
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor(red: 1.0, green: 0.8627, blue: 0.0, alpha: 1.0).cgColor
        button.backgroundColor = .clear
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.purple.cgColor,
            UIColor.red.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        
        
        if let superview = button.superview {
            let adjustedFrame = superview.convert(button.frame, to: superview)
            let backgroundView = UIView(frame: adjustedFrame)
            gradientLayer.frame = CGRect(origin: .zero, size: adjustedFrame.size)
            gradientLayer.cornerRadius = button.layer.cornerRadius
            
            backgroundView.layer.insertSublayer(gradientLayer, at: 0)
            backgroundView.layer.cornerRadius = button.layer.cornerRadius
            backgroundView.layer.shadowColor = UIColor.purple.cgColor
            backgroundView.layer.shadowOffset = CGSize(width: 0, height: 3)
            backgroundView.layer.shadowOpacity = 0.3
            backgroundView.layer.shadowRadius = 6
            backgroundView.layer.masksToBounds = false
            
            superview.addSubview(backgroundView)
            superview.bringSubviewToFront(button)
        }
        
    }
}
