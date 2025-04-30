//
//  CategoryVC.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 16.01.2025.
//

import UIKit
import SwiftUICore

class CategoryVC: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var buttonToplama: UIButton!
    @IBOutlet weak var buttonCikarma: UIButton!
    @IBOutlet weak var buttonCarpma: UIButton!
    @IBOutlet weak var buttonBolme: UIButton!
    @IBOutlet weak var buttonKarisik: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyGradientBackground()
        configureButton(buttonToplama, title: "Toplama", imageName: "addition_icon")
        configureButton(buttonCikarma, title: "Çıkarma", imageName: "subtraction_icon")
        configureButton(buttonCarpma, title: "Çarpma", imageName: "multiplication_icon")
        configureButton(buttonBolme, title: "Bölme", imageName: "division_icon")
        configureButton(buttonKarisik, title: "Karışık", imageName: "mixed_icon")
    }
    
    func applyGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            
            UIColor(red: 200/255, green: 150/255, blue: 50/255, alpha: 1).cgColor,
            UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1).cgColor,
            UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1).cgColor,
            UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1).cgColor
        ]
        
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = view.bounds
        
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        let expressions: [MathExpression.ExpressionType] = [.addition, .subtraction, .multiplication, .division, .mixed]
        let selectedExpression = expressions[sender.tag]
        performSegue(withIdentifier: "goToGame", sender: selectedExpression)
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
    
    func configureButton(_ button : UIButton,title: String,imageName: String ){
        
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor(red: 1.0, green: 0.8627, blue: 0.0, alpha: 1.0).cgColor
        button.backgroundColor = .clear
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        
        
        if let superview = button.superview {
            let adjustedFrame = superview.convert(button.frame, to: superview)
            let backgroundView = UIView(frame: adjustedFrame)
            gradientLayer.frame = CGRect(origin: .zero, size: adjustedFrame.size)
            gradientLayer.cornerRadius = button.layer.cornerRadius
            
            backgroundView.layer.insertSublayer(gradientLayer, at: 0)
            backgroundView.layer.cornerRadius = button.layer.cornerRadius
            backgroundView.layer.shadowOffset = CGSize(width: 0, height: 3)
            backgroundView.layer.shadowOpacity = 0.3
            backgroundView.layer.shadowRadius = 6
            backgroundView.layer.masksToBounds = false
            
            superview.addSubview(backgroundView)
            superview.bringSubviewToFront(button)
        }
        
    }
}
