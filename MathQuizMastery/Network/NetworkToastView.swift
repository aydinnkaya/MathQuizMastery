//
//  NetworkToastView.swift
//  MathQuizMastery
//
//  Created by Aydın KAYA on 12.07.2025.
//

import UIKit

final class NetworkToastView: UIView {
    
    static let shared = NetworkToastView()
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = L(.no_internet_connection)
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.numberOfLines = 2
        return label
    }()
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.red.withAlphaComponent(0.85)
        layer.cornerRadius = 10
        clipsToBounds = true
        addSubview(label)
        
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialLight)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.layer.cornerRadius = 22
        blurView.clipsToBounds = true
        blurView.layer.borderWidth = 1.2
        blurView.layer.borderColor = UIColor.white.withAlphaComponent(0.18).cgColor
        blurView.layer.shadowColor = UIColor.black.withAlphaComponent(0.18).cgColor
        blurView.layer.shadowOpacity = 0.18
        blurView.layer.shadowOffset = CGSize(width: 0, height: 4)
        blurView.layer.shadowRadius = 16
        self.insertSubview(blurView, at: 0)
        NSLayoutConstraint.activate([
            blurView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            blurView.topAnchor.constraint(equalTo: self.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        label.text = L(.no_internet_connection)
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.layer.shadowColor = UIColor.black.withAlphaComponent(0.12).cgColor
        label.layer.shadowOpacity = 0.12
        label.layer.shadowOffset = CGSize(width: 0, height: 1)
        label.layer.shadowRadius = 2
        
        self.layer.cornerRadius = 22
        self.clipsToBounds = true
        self.layoutMargins = UIEdgeInsets(top: 18, left: 24, bottom: 18, right: 24)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = bounds.insetBy(dx: 12, dy: 8)
    }
    
    func show(in window: UIWindow) {
        DispatchQueue.main.async {
            self.removeFromSuperview()
            
            let width: CGFloat = window.bounds.width - 40
            let height: CGFloat = 50
            let topPadding = window.safeAreaInsets.top
            
            self.frame = CGRect(x: 20, y: topPadding + 12, width: width, height: height)
            self.alpha = 0
            window.addSubview(self)
            
            UIView.animate(withDuration: 0.3) {
                self.alpha = 1
            }
        }
    }
    
    func dismiss() {
        DispatchQueue.main.async {
            guard self.superview != nil else { return }
            
            UIView.animate(withDuration: 0.3, animations: {
                self.alpha = 0
            }) { _ in
                self.removeFromSuperview()
            }
        }
    }
}
