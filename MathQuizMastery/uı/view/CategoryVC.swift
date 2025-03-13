//
//  CategoryVC.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 16.01.2025.
//

import UIKit

class CategoryVC: UIViewController {
    
    @IBOutlet weak var buttonToplama: UIButton!
    @IBOutlet weak var buttonCikarma: UIButton!
    @IBOutlet weak var buttonCarpma: UIButton!
    @IBOutlet weak var buttonBolme: UIButton!
    @IBOutlet weak var buttonKarisik: UIButton!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let buttons = [buttonToplama, buttonCikarma, buttonCarpma, buttonBolme, buttonKarisik]
        buttons.forEach { configureButton($0) }
    }
    
    
    @IBAction func buttonToplamaAction(_ sender: Any, forEvent event: UIEvent) {
    }
    
  
    @IBAction func buttonCikarmaAction(_ sender: Any, forEvent event: UIEvent) {
    }
    
    @IBAction func ButtonCarpmaAction(_ sender: Any) {
    }
    
    @IBAction func ButtonBolmeAction(_ sender: Any, forEvent event: UIEvent) {
    }
    
    @IBAction func ButtonKarisikAction(_ sender: UIButton, forEvent event: UIEvent) {
    }
    
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        
        var selectedExpression: MathExpression.ExpressionType? // ifade
        
        switch sender {
        case buttonToplama:
            selectedExpression = .addition
        case buttonCikarma:
            selectedExpression = .subtraction
        case buttonCarpma:
            selectedExpression = .multiplication
        case buttonBolme:
            selectedExpression = .division
        case buttonKarisik:
            selectedExpression = .mixed
        default:
            return
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
    
    
    func configureButton(_ button: UIButton?) {
        guard let button = button else { return }
        
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor(red: 1.0, green: 0.8627, blue: 0.0, alpha: 1.0).cgColor
        button.backgroundColor = .clear
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.purple.cgColor, UIColor.red.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.frame = button.bounds
        gradientLayer.cornerRadius = button.layer.cornerRadius
        
        button.layer.insertSublayer(gradientLayer, at: 0)
        
        button.layer.shadowColor = UIColor.purple.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 6
        button.layer.masksToBounds = false
    }
    
    
}
