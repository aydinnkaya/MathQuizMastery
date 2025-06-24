//
//  FAQViewModel.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 12.06.2025.
//

import Foundation


protocol FAQViewModelDelegate: AnyObject {
    func didUpdateFAQItems()
    func didUpdateFAQItem(at index: Int)
}

class FAQViewModel {
    weak var delegate: FAQViewModelDelegate?
    
    private var items: [FAQItem] = [
        FAQItem(question: "Oyun nasıl oynanır?", 
               answer: "Matematik sorularını doğru cevaplamaya çalışın. Her doğru cevap için puan kazanırsınız.", 
               isExpanded: false),
        FAQItem(question: "Puanlar nasıl hesaplanır?", 
               answer: "Her doğru cevap için 10 puan kazanırsınız. Hızlı cevaplar için bonus puanlar verilir.", 
               isExpanded: false),
        FAQItem(question: "Seviyeler nasıl açılır?", 
               answer: "Her kategoride belirli bir puana ulaştığınızda yeni seviyeler açılır.", 
               isExpanded: false),
        FAQItem(question: "Bildirimler ne işe yarar?", 
               answer: "Günlük pratik hatırlatmaları ve haftalık başarı özetleri için bildirimler alabilirsiniz.", 
               isExpanded: false),
        FAQItem(question: "Profil resmimi nasıl değiştirebilirim?", 
               answer: "Ayarlar > Profil menüsünden avatar seçimi yapabilirsiniz.", 
               isExpanded: false)
    ]
    
    var numberOfItems: Int {
        return items.count
    }
    
    func item(at index: Int) -> FAQItem {
        return items[index]
    }
    
    func toggleExpansion(at index: Int) {
        guard items.indices.contains(index) else { return }
        items[index].isExpanded.toggle()
        delegate?.didUpdateFAQItem(at: index)
    }
}
