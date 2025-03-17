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
    
    /*
     private func setupButtons() {
     let titles = ["Toplama", "Çıkarma", "Çarpma", "Bölme", "Karışık"]
     let expressions: [MathExpression.ExpressionType] = [.addition, .subtraction, .multiplication, .division, .mixed]
     
     for (index, title) in titles.enumerated() {
     let button = createHexButton(title: title)
     button.tag = index
     button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
     stackView.addArrangedSubview(button)
     }
     
     
     */
    
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
        //        gradientLayer.colors = [
        //            UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1).cgColor, // Koyu gri
        //            UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1).cgColor, // Orta gri
        //            UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1).cgColor, // Açık gri
        //            UIColor(red: 200/255, green: 150/255, blue: 50/255, alpha: 1).cgColor  // Altın sarısı parıltı
        //        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        
        
        if let superview = button.superview {
            let adjustedFrame = superview.convert(button.frame, to: superview)
            let backgroundView = UIView(frame: adjustedFrame)
            gradientLayer.frame = CGRect(origin: .zero, size: adjustedFrame.size)
            gradientLayer.cornerRadius = button.layer.cornerRadius
            
            backgroundView.layer.insertSublayer(gradientLayer, at: 0)
            backgroundView.layer.cornerRadius = button.layer.cornerRadius
            // backgroundView.layer.shadowColor = UIColor.purple.cgColor
            backgroundView.layer.shadowOffset = CGSize(width: 0, height: 3)
            backgroundView.layer.shadowOpacity = 0.3
            backgroundView.layer.shadowRadius = 6
            backgroundView.layer.masksToBounds = false
            
            superview.addSubview(backgroundView)
            superview.bringSubviewToFront(button)
        }
        
        
//        let stackView = UIStackView()
//               stackView.axis = .vertical
//               stackView.alignment = .center
//               stackView.spacing = 8
//               stackView.frame = button.bounds
//               
//               let imageView = UIImageView()
//               imageView.image = UIImage(named: imageName)
//               imageView.contentMode = .scaleAspectFit
//               imageView.frame = CGRect(x: 0, y: 0, width: button.frame.width * 0.6, height: button.frame.height * 0.5)
//               
//               let label = UILabel()
//               label.text = title
//               label.textColor = .white
//               label.font = UIFont.boldSystemFont(ofSize: 18)
//               label.textAlignment = .center
//               
//               stackView.addArrangedSubview(imageView)
//               stackView.addArrangedSubview(label)
//               button.addSubview(stackView)
        
    }
    
    
    
    
    /*
     private func createHexButton(title: String) -> UIButton {
     let button = UIButton(type: .system)
     button.setTitle(title, for: .normal)
     button.setTitleColor(.white, for: .normal)
     button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
     
     let hexSize = CGSize(width: 140, height: 120)
     button.frame = CGRect(origin: .zero, size: hexSize)
     button.clipsToBounds = true
     
     let hexPath = createHexagonPath(in: CGRect(origin: .zero, size: hexSize))
     applyHexagonMask(to: button, path: hexPath)
     
     let gradientColors = [UIColor.systemBlue.cgColor, UIColor.systemPurple.cgColor]
     applyGradient(to: button, colors: gradientColors, path: hexPath)
     
     applyShadow(to: button)
     return button
     }
     
     private func applyHexagonMask(to view: UIView, path: UIBezierPath) {
     let shapeLayer = CAShapeLayer()
     shapeLayer.path = path.cgPath
     view.layer.mask = shapeLayer
     }
     
     private func applyGradient(to view: UIView, colors: [CGColor], path: UIBezierPath) {
     let gradientLayer = CAGradientLayer()
     gradientLayer.colors = colors
     gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
     gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
     gradientLayer.frame = view.layer.bounds
     
     let maskLayer = CAShapeLayer()
     maskLayer.path = path.cgPath
     gradientLayer.mask = maskLayer
     
     view.layer.insertSublayer(gradientLayer, at: 0)
     }
     
     private func applyShadow(to view: UIView) {
     view.layer.shadowColor = UIColor.black.cgColor
     view.layer.shadowOffset = CGSize(width: 3, height: 4)
     view.layer.shadowOpacity = 0.4
     view.layer.shadowRadius = 5
     view.layer.masksToBounds = false
     }
     
     private func createHexagonPath(in rect: CGRect) -> UIBezierPath {
     let path = UIBezierPath()
     let width = rect.width
     let height = rect.height
     let sideLength = width / 2
     let deltaY = sideLength * sqrt(3) / 2
     
     path.move(to: CGPoint(x: width * 0.5, y: 0))
     path.addLine(to: CGPoint(x: width, y: deltaY))
     path.addLine(to: CGPoint(x: width, y: height - deltaY))
     path.addLine(to: CGPoint(x: width * 0.5, y: height))
     path.addLine(to: CGPoint(x: 0, y: height - deltaY))
     path.addLine(to: CGPoint(x: 0, y: deltaY))
     path.close()
     
     return path
     }
     */
}
