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
    
    // MARK: - Localized FAQ Items
    private var items: [FAQItem] = [
        FAQItem(question: L(.faq_q1),
               answer: L(.faq_a1),
               isExpanded: false),
        FAQItem(question: L(.faq_q2),
               answer: L(.faq_a2),
               isExpanded: false),
        FAQItem(question: L(.faq_q3),
               answer: L(.faq_a3),
               isExpanded: false),
        FAQItem(question: L(.faq_q4),
               answer: L(.faq_a4),
               isExpanded: false),
        FAQItem(question: L(.faq_q5),
               answer: L(.faq_a5),
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
