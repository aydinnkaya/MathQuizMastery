//
//  ResultVC.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 14.01.2025.
//

import UIKit

class ResultVC: UIViewController {
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var restartButton: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var coinLabel: UILabel!
    
    var receivedScore: String = "0"
    var viewModel: ResultViewModelProtocol!
    var coordinator: AppCoordinator!
    
    
    init(viewModel: ResultViewModelProtocol, coordinator: AppCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: "ResultVC", bundle: nil)
        self.viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("Storyboard üzerinden başlatma kullanılmıyor.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scoreLabel.text = viewModel.getScoreText()
        coinLabel.text = viewModel.getCoinText()
        categoryButton.clipsToBounds = true
        navigationItem.hidesBackButton = true
        
        viewModel.delegate = self
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupBackground()
    }
    
    private func setupUI() {
        categoryButton.clipsToBounds = true
        navigationItem.hidesBackButton = true
    }
    
    @IBAction func goToHome(_ sender: Any) {
        viewModel.handleHomeTapped()
    }
    
    @IBAction func goToCategory(_ sender: Any) {
        viewModel.handleCategoryTapped()
    }
    
    @IBAction func goToRestart(_ sender: Any) {
        viewModel.handleRestartTapped()
    }
    
}

extension ResultVC : ResultViewModelDelegate {
    
    func navigateToHome() {
        self.coordinator.goToHomeAfterResult()
    }
    
    func navigateToCategory() {
        self.coordinator.goToCategory()
    }
    
    func restartGame(with type: MathExpression.ExpressionType) {
        self.coordinator.restartGame(with: type)
    }
    
}

extension ResultVC {
    private func setupBackground(){
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        
        gradientLayer.colors = UIColor.Custom.galacticBackground as [Any]
        
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.locations = [0.0, 0.2, 0.4, 0.6, 0.8, 1.0] as [NSNumber]
        gradientLayer.opacity = 0.95
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
}

