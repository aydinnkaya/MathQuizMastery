//
//  FAQViewModel.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 12.06.2025.
//

import Foundation

protocol FAQViewModelProtocol {
    var delegate: FAQViewModelDelegate? { get set }
    var items: [FAQItem] { get }
    
    func toggleItem(at index: Int)
}

protocol FAQViewModelDelegate: AnyObject {
    func didUpdateFAQItems()
}

class FAQViewModel: FAQViewModelProtocol {
    
    weak var delegate: FAQViewModelDelegate?
    
    private(set) var items: [FAQItem]
    
    init() {
        self.items = [
            FAQItem(question: "MathQuizMastery nedir?",
                   answer: "MathQuizMastery, matematiksel işlem becerilerinizi geliştiren eğlenceli ve öğretici bir quiz oyunudur.",
                   isExpanded: false),
            FAQItem(question: "Nasıl oynanır?",
                   answer: "Kategori seçtikten sonra karşınıza çıkan matematik sorularını süre dolmadan yanıtlamalısınız.",
                   isExpanded: false),
            FAQItem(question: "Kategori türleri nelerdir?",
                   answer: "Toplama, çıkarma, çarpma, bölme, karışık işlemler ve zorluk seviyelerine göre kategoriler mevcuttur.",
                   isExpanded: false),
            FAQItem(question: "Puanlar nasıl hesaplanıyor?",
                   answer: "Doğru cevap, süreye göre bonus ve zorluk seviyesine göre ekstra puan verilir.",
                   isExpanded: false),
            FAQItem(question: "Yanlış cevap verirsem ne olur?",
                   answer: "Yanlış cevap verdiğinizde doğru cevabı öğrenirsiniz ve puan alamazsınız.",
                   isExpanded: false),
            FAQItem(question: "Ses ve animasyonları kapatabilir miyim?",
                   answer: "Evet, Ayarlar menüsünden sesleri ve animasyonları kapatabilirsiniz.",
                   isExpanded: false),
            FAQItem(question: "İstatistiklerimi nereden görebilirim?",
                   answer: "Ana ekrandan 'Profil' bölümüne girerek başarılarınızı ve istatistiklerinizi görebilirsiniz.",
                   isExpanded: false),
            FAQItem(question: "Bu oyun hangi yaş grubuna uygundur?",
                   answer: "Temel aritmetik bilgisine sahip 7 yaş ve üzeri herkes için uygundur.",
                   isExpanded: false)
        ]
    }
    
    func toggleItem(at index: Int) {
        guard items.indices.contains(index) else { return }
        items[index].isExpanded.toggle()
        delegate?.didUpdateFAQItems()
    }
}
