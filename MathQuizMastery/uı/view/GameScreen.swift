//
//  ViewController.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 9.01.2025.
//

import UIKit

class GameScreen: UIViewController {
    @IBOutlet weak var questionView: UIView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var buttonFirst: UIButton!
    @IBOutlet weak var buttonSecond: UIButton!
    @IBOutlet weak var buttonThird: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 242/255, green: 238/255, blue: 230/255, alpha: 1.0)
        updateQuestionLabel()
        setupQuestionView()
        setupButtonView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupButtonView()
    }
    
    func updateQuestionLabel() {
        let randomExpression = MathExpression.randomExpression()
        questionLabel.text = randomExpression.getExpression()
    }
    
    private func setupQuestionView(){
        questionView.backgroundColor = UIColor(red: 210/255, green: 240/255, blue: 240/255, alpha: 1.0)
        questionView.layer.cornerRadius = 20
        questionView.layer.masksToBounds = false
        
        questionView.layer.shadowColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1.0).cgColor
        questionView.layer.shadowOffset = CGSize(width: 5, height: 5)
        questionView.layer.opacity = 0.4
        questionView.layer.shadowRadius = 8
        questionView.layer.borderWidth = 5
    }
    
    private func setupButtonView(){
        let buttonList = [buttonFirst,buttonSecond,buttonThird]
        
        for b in buttonList {
            b?.isHidden = false
            b?.backgroundColor = UIColor(red: 255/255, green: 230/255, blue: 150/255, alpha: 1.0)
            b?.layer.cornerRadius = 25
            b?.layer.shadowColor = UIColor(red: 180/255, green: 180/255, blue: 180/255, alpha: 1.0).cgColor
            b?.layer.shadowOffset = CGSize(width: 3, height: 3)
            b?.layer.shadowOpacity = 0.6
            b?.layer.shadowRadius = 5
        }
    }
    
    
    
    @IBAction func answerSecondButton(_ sender: Any) {
        
    }
    
    @IBAction func answerThirdButton(_ sender: Any) {
    }
}

