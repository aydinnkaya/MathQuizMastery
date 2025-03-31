//
//  ToastView.swift
//  MathQuizMastery
//
//  Created by Aydın KAYA on 31.03.2025.
//

import Foundation
import UIKit


final class ToastView: UILabel {
    
    static func show(in view: UIView, message: String, duration: TimeInterval = 2.0) {
        let toast = ToastView()
        toast.text = message
        toast.textColor = .white
        toast.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        toast.textAlignment = .center
        toast.font = .systemFont(ofSize: 14, weight: .medium)
        toast.numberOfLines = 0
        toast.layer.cornerRadius = 10
        toast.clipsToBounds = true
        toast.alpha = 0.0
        
        let maxWidth = view.frame.width * 0.8
        let size = toast.sizeThatFits(CGSize(width: maxWidth, height: .greatestFiniteMagnitude))
        toast.frame = CGRect(x: (view.frame.width - maxWidth) / 2, y: 100, width: maxWidth, height: size.height + 16)
        toast.layer.zPosition = 999
        
        view.addSubview(toast)
        
        UIView.animate(withDuration: 0.3, animations: {
            toast.alpha = 1.0
        }) { _ in
            UIView.animate(withDuration: 0.5, delay: duration, options: .curveEaseOut, animations: {
                toast.alpha = 0.0
            }, completion: { _ in
                toast.removeFromSuperview()
            })
        }
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
