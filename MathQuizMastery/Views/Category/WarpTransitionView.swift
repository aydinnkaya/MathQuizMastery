//
//  WarpTransitionView.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 6.05.2025.
//

import UIKit

final class WarpTransitionView: UIView {
    
    private let warpLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupWarpEffect()
        animateWarp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupWarpEffect()
        animateWarp()
    }
    
    private func setupWarpEffect() {
        backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
        warpLayer.frame = bounds
        warpLayer.colors = [
            UIColor.white.cgColor,
            UIColor.systemCyan.cgColor,
            UIColor.black.cgColor
        ]
        warpLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        warpLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        warpLayer.locations = [0.0, 0.5, 1.0]
        layer.addSublayer(warpLayer)
    }
    
    private func animateWarp() {
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [0.0, 0.0, 0.25]
        animation.toValue = [0.75, 1.0, 1.0]
        animation.duration = 0.6
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        warpLayer.add(animation, forKey: "warpMove")
    }
    
    override func removeFromSuperview() {
        UIView.animate(withDuration: 0.4, animations: {
            self.alpha = 0
        }) { _ in
            super.removeFromSuperview()
        }
    }
}
