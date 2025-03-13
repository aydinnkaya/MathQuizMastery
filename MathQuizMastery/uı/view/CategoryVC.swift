//
//  CategoryVC.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 16.01.2025.
//

import UIKit

class CategoryVC: UIViewController {
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var buttonToplama: UIButton!
    @IBOutlet weak var buttonCikarma: UIButton!
    @IBOutlet weak var buttonCarpma: UIButton!
    @IBOutlet weak var buttonBolme: UIButton!
    @IBOutlet weak var buttonKarisik: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStackView()
        setupButtons()
    }
    
    private func setupStackView() {
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 16
    }
    
    private func setupButtons() {
        let titles = ["Toplama", "Çıkarma", "Çarpma", "Bölme", "Karışık"]
        let expressions: [MathExpression.ExpressionType] = [.addition, .subtraction, .multiplication, .division, .mixed]
        
        for (index, title) in titles.enumerated() {
            let button = createHexButton(title: title)
            button.tag = index
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            stackView.addArrangedSubview(button)
        }
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
}
